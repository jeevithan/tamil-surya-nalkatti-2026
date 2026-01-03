import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; 
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'தமிழ் சூரிய நாட்காட்டி',
      home: MonthlyCalendarPage(),
    );
  }
}

class MonthlyCalendarPage extends StatefulWidget {
  const MonthlyCalendarPage({super.key});

  @override
  MonthlyCalendarPageState createState() => MonthlyCalendarPageState();
}

class MonthlyCalendarPageState extends State<MonthlyCalendarPage> {
  // State variables
  List<Map<String, dynamic>> tamilMonths = []; 
  bool isLoading = true; 
  int currentMonthIndex = 0;
  DateTime? selectedDay;
  Map<String, List<String>> formattedSampleEvents = {};
  
  // Instance variables for specific day details (optional, mostly used in loop)
  String? pagai; 
  String? neramn; 

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      await Future.wait([
        fetchTamilMonths(),
        fetchEvents()
      ]);
    } catch (e) {
      debugPrint("Error loading data: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchTamilMonths() async {
    const url = 'https://tamilsuncalendar.com/build/tamilmonths.json';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          tamilMonths = jsonData
              .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)
              .toList();
        });
      } else {
        throw Exception('Failed to load tamil months');
      }
    } catch (e) {
      debugPrint("Error fetching months: $e");
    }
  }

  Future<void> fetchEvents() async {
    const url = 'https://tamilsuncalendar.com/build/calendar_data.json';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        List<dynamic> eventsList = jsonData['dailyCalendarStatics'];
        formatSampleData(eventsList);
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      debugPrint("Error fetching events: $e");
    }
  }

  String getGregorianMonthName(String startDate, String endDate) {
    try {
      DateTime start = DateTime.parse(startDate);
      DateTime end = DateTime.parse(endDate);
      String startMonthName = DateFormat.MMMM().format(start);
      String endMonthName = DateFormat.MMMM().format(end);

      if (startMonthName == endMonthName) {
        return startMonthName;
      } else {
        return '$startMonthName - $endMonthName';
      }
    } catch (e) {
      return "";
    }
  }

  void formatSampleData(List<dynamic> data) {
    for (var event in data) {
      String date = event['calendarDate'];
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
      String englishDate = DateFormat('dd-MM-yyyy').format(parsedDate);

      List<String> details = [];
      if (event['calendarDate'] != null && event['calendarDate'].isNotEmpty) {
        details.add('ஆங்கில தேதி: $englishDate');
      }
      if (event['yugam'] != null && event['yugam'].isNotEmpty) {
        details.add('கலியுகாதி: ${event['yugam']}');
      }
      if (event['aandu'] != null && event['aandu'].isNotEmpty) {
        details.add('ஆண்டு: ${event['aandu']}');
      }
      if (event['matham'] != null && event['matham'].isNotEmpty) {
        details.add('மாதம்: ${event['matham']} ${event['thethi']} ம் நாள்');
      }
      if (event['kilamai'] != null && event['kilamai'].isNotEmpty) {
        details.add('கிழமை: ${event['kilamai']}');
      }
      if (event['payanam'] != null && event['payanam'].isNotEmpty) {
        details.add('சூரிய பயணம்: ${event['payanam']}');
      }
      if (event['kaalam'] != null && event['kaalam'].isNotEmpty) {
        details.add('பெரும் பொழுது: ${event['kaalam']}');
      }
      if (event['paruvanilai'] != null && event['paruvanilai'].isNotEmpty) {
        details.add('பருவநிலை: ${event['paruvanilai']}');
      }
      if (event['thithi'] != null && event['thithi'].isNotEmpty) {
        details.add('திதி: ${event['thithi']}${event['thithi_arambam']} முதல்');
      }
      if (event['natchatram'] != null && event['natchatram'].isNotEmpty) {
        details.add(
            'நட்சத்திரம்: ${event['natchatram']}${event['natchatram_arambam']} முதல்');
      }
      if (event['sunrise'] != null && event['sunrise'].isNotEmpty) {
        String sunriseTime = convertTo12HourFormat(event['sunrise']);
        details.add('சூரிய உதயம்: $sunriseTime');
      }
      if (event['sunset'] != null && event['sunset'].isNotEmpty) {
        String sunsetTime = convertTo12HourFormat(event['sunset']);
        details.add('சூரிய அஸ்தமனம்: $sunsetTime');
      }
      if (event['sirapu'] != null && event['sirapu'].isNotEmpty) {
        details.add('இன்றைய சிறப்பு: ${event['sirapu']}');
      }
      if (event['ponmoli'] != null && event['ponmoli'].isNotEmpty) {
        details.add('பொன்மொழிகள்: ${event['ponmoli']}');
      }
      
      if (event['pagai'] != null && event['pagai'].isNotEmpty) {
        pagai = event['pagai']; 
      }
      if (event['neramn'] != null && event['neramn'].isNotEmpty) {
        neramn = event['neramn'];
      }
      
      String eventDetail = details.join(', ');

      if (!formattedSampleEvents.containsKey(formattedDate)) {
        formattedSampleEvents[formattedDate] = [eventDetail];
      } else {
        formattedSampleEvents[formattedDate]!.add(eventDetail);
      }
    }
  }

  String convertTo12HourFormat(String time) {
    try {
      DateTime parsedTime = DateFormat("HH:mm").parse(time);
      return DateFormat("h:mm a").format(parsedTime);
    } catch (e) {
      return "Invalid Time";
    }
  }

  void goToNextMonth() {
    setState(() {
      if (currentMonthIndex < tamilMonths.length - 1) {
        currentMonthIndex++;
        selectedDay = null; 
      }
    });
  }

  void goToPreviousMonth() {
    setState(() {
      if (currentMonthIndex > 0) {
        currentMonthIndex--;
        selectedDay = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color customColor = Color.fromRGBO(96, 29, 48, 1);

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: customColor),
        ),
      );
    }

    if (tamilMonths.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No calendar data available.")),
      );
    }

    // Extract Data for UI
    Map<String, dynamic> currentMonth = tamilMonths[currentMonthIndex];
    
    // --- START: Dynamic Data Extraction ---
    String aanddu = currentMonth["aanddu"] ?? ""; // Get 'aandu' from JSON
    String tamilMonthName = currentMonth["tamilmonth"] ?? "";
    String monthNeramn = currentMonth["neramn"] ?? "Unavailable";
    String monthPagai = currentMonth["pagai"] ?? "Unavailable";
    
    DateTime startDate = DateTime.parse(currentMonth["startdate"]);
    DateTime endDate = DateTime.parse(currentMonth["enddate"]);
    // --- END: Dynamic Data Extraction ---
    
    int daysInMonth = endDate.difference(startDate).inDays + 1;
    String gregorianMonthName = getGregorianMonthName(
        currentMonth["startdate"], currentMonth["enddate"]);

    int startDayOfWeek = startDate.weekday;
    int adjustedStartDayOfWeek = startDayOfWeek % 7;
    int totalItems = daysInMonth + adjustedStartDayOfWeek;

    List<String> dayNames = [
      'ஞாயிறு', 'திங்கள்', 'செவ்வாய்', 'புதன்', 'வியாழன்', 'வெள்ளி', 'சனி'
    ];

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40), 
          
          // --- UPDATED TEXT WIDGET ---
          Text(
            '$aanddu', 
            style: const TextStyle(fontSize: 16),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: currentMonthIndex > 0 ? goToPreviousMonth : null,
                color: currentMonthIndex > 0 ? Colors.black : Colors.grey,
              ),
              Text(
                '$tamilMonthName / $gregorianMonthName',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: currentMonthIndex < tamilMonths.length - 1 ? goToNextMonth : null,
                color: currentMonthIndex < tamilMonths.length - 1 ? Colors.black : Colors.grey,
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: customColor,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   const Text(
                    "மாத பிறப்பு:",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    "நேரம்: $monthNeramn",
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  Text(
                    "பாகை: $monthPagai",
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: dayNames
                  .map((day) => Expanded(
                        child: Text(
                          day,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ))
                  .toList(),
            ),
          ),
          
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 0.9, 
              ),
              itemCount: totalItems,
              itemBuilder: (context, index) {
                if (index < adjustedStartDayOfWeek) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 0.5),
                    ),
                  );
                } else {
                  DateTime currentDate = startDate
                      .add(Duration(days: index - adjustedStartDayOfWeek));
                  
                  String tamilDateStr = "${index - adjustedStartDayOfWeek + 1}";
                  String gregorianDateStr = "${currentDate.day}";
                  
                  bool isSelected = selectedDay != null && 
                      selectedDay!.year == currentDate.year &&
                      selectedDay!.month == currentDate.month &&
                      selectedDay!.day == currentDate.day;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedDay = currentDate;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300, width: 0.5),
                        color: isSelected
                            ? const Color.fromRGBO(242, 237, 245, 1)
                            : const Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              tamilDateStr,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: customColor,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                gregorianDateStr,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Color.fromRGBO(96, 29, 48, 1)),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                tamilMonthName,
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: customColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          
          if (selectedDay != null)
            Expanded(
              child: Container(
                color: Colors.grey.shade50,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: formattedSampleEvents[
                              DateFormat('yyyy-MM-dd').format(selectedDay!)]
                          ?.map((event) {
                        List<String> details = event.split(', ');
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: details.map((detail) {
                                List<String> keyValue = detail.split(': ');
                                if (keyValue.length < 2) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      detail,
                                      style: GoogleFonts.notoSansTamil(
                                        textStyle: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: keyValue[0].replaceAll(RegExp(' +'), ' ') + ': ',
                                          style: GoogleFonts.notoSansTamil(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: customColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: keyValue.sublist(1).join(': ').replaceAll(RegExp(' +'), ' '),
                                          style: GoogleFonts.notoSansTamil(
                                            textStyle: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }).toList() ??
                      [
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: Text("No events found for this date")),
                        )
                      ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
import 'dart:convert';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DailyCalendarPage extends StatefulWidget {
  const DailyCalendarPage({super.key});

  @override
  _DailyCalendarPageState createState() => _DailyCalendarPageState();
}

class _DailyCalendarPageState extends State<DailyCalendarPage> {
  Map<String, List<String>> formattedSampleEvents = {};
  DateTime _focusDate = DateTime.now();

  String _highlightedDay = '';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting("ta").then((_) {
      fetchEvents();
    });
  }

  Future<void> fetchEvents() async {
    const url = 'https://tamilsuncalendar.com/build/calendar_data.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> eventsList = jsonData['dailyCalendarStatics'];
      formatSampleData(eventsList);
    } else {
      throw Exception('Failed to load events');
    }
  }

  void formatSampleData(List<dynamic> data) {
    for (var event in data) {
      String date = event['calendarDate'];
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      List<String> details = [];
      if (event['calendarDate'] != null && event['calendarDate'].isNotEmpty) {
        details
            .add('ஆங்கில தேதி: ${DateFormat('dd-MM-yyyy').format(parsedDate)}');
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
            'நட்சத்திரம்: ${event['natchatram']} ${event['natchatram_arambam']} முதல்');
      }
      if (event['sunrise'] != null && event['sunrise'].isNotEmpty) {
        details.add('சூரிய உதயம்: ${convertTo12HourFormat(event['sunrise'])}');
      }
      if (event['sunset'] != null && event['sunset'].isNotEmpty) {
        details
            .add('சூரிய அஸ்தமனம்: ${convertTo12HourFormat(event['sunset'])}');
      }
      if (event['sirapu'] != null && event['sirapu'].isNotEmpty) {
        details.add('இன்றைய சிறப்பு: ${event['sirapu']}');
      }
      if (event['ponmoli'] != null && event['ponmoli'].isNotEmpty) {
        details.add('பொன்மொழிகள்: ${event['ponmoli']}');
      }

      if (!formattedSampleEvents.containsKey(formattedDate)) {
        formattedSampleEvents[formattedDate] = details;
      } else {
        formattedSampleEvents[formattedDate]!.addAll(details);
      }
    }

    // Update highlighted day when data is fetched
    _updateHighlightedDay();
  }

  void _updateHighlightedDay() {
    final key = _focusDate.toIso8601String().substring(0, 10);
    if (formattedSampleEvents.containsKey(key)) {
      final details = formattedSampleEvents[key]!;
      final matham = details.firstWhere(
        (detail) => detail.contains('மாதம்:'),
        orElse: () => '',
      );
      if (matham.isNotEmpty) {
        final thethiMatch = RegExp(r'\d+').firstMatch(matham);
        if (thethiMatch != null) {
          final thethi = thethiMatch.group(0);
          final monthName =
              matham.split(':')[1].split(' ')[1]; // Extracts the month name
          setState(() {
            _highlightedDay = '$monthName $thethi ம் நாள்';
          });
        }
      }
    }
  }

  String convertTo12HourFormat(String time) {
    DateTime dateTime = DateFormat("HH:mm").parse(time);
    return DateFormat("h:mm a").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    const Color customColor = Color.fromRGBO(96, 29, 48, 1);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: EasyInfiniteDateTimeLine(
              locale: "ta",
              activeColor: const Color(0xffB04759),
              firstDate: DateTime(2025, 12, 14),
              focusDate: _focusDate,
              lastDate: DateTime(2027, 1, 13),
              onDateChange: (selectedDate) {
                setState(() {
                  _focusDate = selectedDate;
                  _updateHighlightedDay();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffF3F2F7),
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  _highlightedDay,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffB04759),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: formattedSampleEvents[
                          _focusDate.toIso8601String().substring(0, 10)]
                      ?.map((event) {
                    return ListTile(
                      dense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: event.split(', ').map((detail) {
                          List<String> keyValue = detail.split(': ');
                          if (keyValue.length < 2) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: Text(
                                detail,
                                style: GoogleFonts.notoSansTamil(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${keyValue[0]
                                            .replaceAll(RegExp(' +'), ' ')}: ',
                                    style: GoogleFonts.notoSansTamil(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: customColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  ...keyValue[1]
                                      .split(', ')
                                      .map((subText) => TextSpan(
                                            text: '${subText.replaceAll(
                                                    RegExp(' +'), ' ')} ',
                                            style: GoogleFonts.notoSansTamil(
                                              textStyle: TextStyle(
                                                color: customColor,
                                              ),
                                            ),
                                          ))
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList() ??
                  [const Text("No events")],
            ),
          ),
        ],
      ),
    );
  }
}

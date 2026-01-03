import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'about_page.dart';
import 'contact_page.dart';
import 'daily_calendar_page.dart';
import 'home_page.dart';
import 'monthly_calendar_page.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'தமிழ் சூரிய நாட்காட்டி',
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTamilTextTheme(),
        primarySwatch: Colors.red,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DailyCalendarPage(),
    MonthlyCalendarPage(),
    HomePage(),
    AboutPage(),
    ContactPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // Remove padding from the ListView
          children: <Widget>[
            SizedBox(
              height:
                  200.0, // Match the height of the DrawerHeader to the image height
              child: DrawerHeader(
                padding: EdgeInsets.zero, // Remove the default padding
                margin: EdgeInsets.zero, // Remove margin
                child: Image.asset(
                  'assets/images/sun.png',
                  fit: BoxFit.cover, // Cover the entire DrawerHeader
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            ListTile(
              leading:
                  const Icon(Icons.home), // Same icon as bottom navigation bar
              title: const Text('முகப்பு'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons
                  .calendar_view_month), // Same icon as bottom navigation bar
              title: const Text('தமிழ் சூரிய நாட்காட்டி'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(
                  Icons.calendar_today), // Same icon as bottom navigation bar
              title: const Text('தினசரி நாட்காட்டி'),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading:
                  const Icon(Icons.info), // Same icon as bottom navigation bar
              title: const Text('கூடுதல் தகவல்கள்'),
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: const Icon(Icons.contact_page),
              title: const Text('தொடர்பு'),
              onTap: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            backgroundColor: const Color.fromRGBO(96, 29, 48, 1),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: 16.0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/icon.svg',
                    height: 24.0,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    // Add this Flexible widget to allow wrapping
                    child: Text(
                      'தமிழ் சூரிய நாட்காட்டி',
                      style: GoogleFonts.notoSansTamil(
                        fontSize: 14, // Adjust the font size if necessary
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow:
                          TextOverflow.ellipsis, // This helps prevent overflow
                      softWrap: true, // Allow text wrapping
                    ),
                  ),
                ],
              ),
              background: Image.asset(
                'assets/images/sun.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: const Color.fromRGBO(96, 29, 48, 1),
              height: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: const Color.fromRGBO(96, 29, 48, 1),
        style: TabStyle.react,
        items: const [
          TabItem(icon: Icons.calendar_today),
          TabItem(icon: Icons.calendar_view_month),
          TabItem(icon: Icons.home),
          TabItem(icon: Icons.info),
          TabItem(icon: Icons.contact_page),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}

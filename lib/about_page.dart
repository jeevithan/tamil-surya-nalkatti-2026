import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<Map<String, dynamic>> fetchContent() async {
    const url = 'https://tamilsuncalendar.com/build/about.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load content');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final List<dynamic> contentItems = data['content'] as List<dynamic>;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16.0), // Add bottom padding
                    child: Text(
                      data['title'] ?? '',
                      style: GoogleFonts.notoSansTamil(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      data['introduction'] ?? '',
                      style: GoogleFonts.notoSansTamil(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      data['sub_title'] ?? '',
                      style: GoogleFonts.notoSansTamil(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ...contentItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(
                          bottom: 16.0), // Add bottom padding
                      child: Text(
                        item['text']?.replaceAll('<br/>', '\n') ??
                            '', // Replace <br/> with \n
                        style: GoogleFonts.notoSansTamil(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16.0), // Add bottom padding
                    child: Text(
                      data['footer'] ?? '',
                      style: GoogleFonts.notoSansTamil(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No content available'));
          }
        },
      ),
    );
  }
}

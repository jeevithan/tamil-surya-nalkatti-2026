import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // <-- Make sure this line is added
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Page Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactPage(),
    );
  }
}

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Prepare data to be sent
      final data = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'subject': _subjectController.text,
        'message': _messageController.text,
      };

      // Call function to send data to your backend server
      await _sendDataToServer(data);
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      print('Could not launch $email');
    }
  }

  Future<void> _sendDataToServer(Map<String, String> data) async {
    // URL of your backend server
    const url = 'https://tamilsuncalendar.com/mailer.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email sent successfully')),
        );

        // Clear the form fields
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _subjectController.clear();
        _messageController.clear();
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send email')),
        );
      }
    } catch (e) {
      // Handle network error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'மேலும் விவரங்களுக்கு, தொடர்பு கொள்ளவும்',
          style: TextStyle(
            color: Colors.black, // Black color for the preceding text
            fontWeight: FontWeight.bold, // Bold text
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Form fields
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'பெயர்'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'உங்களுடைய பெயரை பதிவு செய்யவும்';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'மின்னஞ்சல்'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'உங்கள் மின்னஞ்சலை உள்ளிடவும்';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'கைபேசி எண்'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'உங்கள் மொபைல் எண்ணை உள்ளிடவும்';
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(labelText: 'தலைப்பு'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'உங்கள் தலைப்பை உள்ளிடவும்';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(labelText: 'கருத்துக்கள்'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'தயவுசெய்து உங்கள் கருத்துக்களை உள்ளிடவும்';
                    }
                    return null;
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('அனுப்புக'),
                  ),
                ),
                Divider(),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 32.0), // Add bottom padding
                  child: Text(
                    'கணித்தவர்: இரா. செந்தில்குமார் எம்.எ. தமிழ்.,',
                    style: GoogleFonts.notoSansTamil(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                Text('இடம்: குன்னூர்.'),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'மின்னஞ்சல்: ',
                        style: TextStyle(
                          color: Colors
                              .black, // Black color for the preceding text
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                      TextSpan(
                        text: 'tamilsuncalendar@gmail.com',
                        style: TextStyle(
                          color: Colors
                              .blue, // Blue color to make it look like a link
                          decoration: TextDecoration.none, // No underline
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchEmail('tamilsuncalendar@gmail.com');
                          },
                      ),
                    ],
                  ),
                ),

                Text('அட்சரேகை: வ 11° 35\' 17.46"'),
                Text('தீர்க்கரேகை: கி 77° 19\' 21.20" '),
                Text('உயரம்: 1768 மீ.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      TextEditingController controller, String label,
      [String? validationError,
      bool emailValidation = false,
      int maxLines = 1]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationError;
        }
        if (emailValidation && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';
        }
        return null;
      },
    );
  }

 
}

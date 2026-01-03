import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(139, 28, 59, 1),
              const Color.fromRGBO(96, 29, 48, 1)
            ], // Red gradient colors
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/icon.svg',
                width: 120.0,
                color: Color(0xffefcd67),
              ),
              const SizedBox(height: 20),
              const Text(
                'தமிழ் சூரிய நாட்காட்டி',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white, // Changed to white for better visibility
                ),
              ),
              const Text(
                '',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white, // Changed to white for better visibility
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

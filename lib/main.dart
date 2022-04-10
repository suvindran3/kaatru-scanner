import 'package:device_scanner/screens/sign_in_screen.dart';
import 'package:device_scanner/screens/scanned_screen.dart';
import 'package:device_scanner/screens/splash_screen.dart';
import 'package:device_scanner/test.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          headline6:
              GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.bold),
          bodyText2: GoogleFonts.sourceSansPro(),
          headline1:
              GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 23),
          button: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
          subtitle1: GoogleFonts.sourceSansPro(color: Colors.grey),
          subtitle2: GoogleFonts.outfit(),
        ),
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: Colors.brown,
            ),
      ),
      home: const Test(),
    );
  }
}

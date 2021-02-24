import 'package:flutter/material.dart';
import 'package:weather_flutter_app/screens/loading_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.comfortaaTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
      home: LoadingScreen(),
    );
  }
}

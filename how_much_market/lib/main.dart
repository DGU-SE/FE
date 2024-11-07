import 'package:flutter/material.dart';
import 'package:how_much_market/screens/main/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0XFF523B2A),
          ),
        ),
        cardColor: const Color(0xffDEEABB),
        primaryColor: const Color(0xff3297DF),
        primaryColorDark: const Color(0XFF523B2A),
        primaryColorLight: const Color.fromARGB(255, 255, 246, 225),
        colorScheme: ColorScheme.fromSwatch(
            backgroundColor: const Color.fromARGB(255, 253, 255, 249)),
      ),
      home: const HomeScreen(),
    );
  }
}

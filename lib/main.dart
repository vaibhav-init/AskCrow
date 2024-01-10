import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
// import 'presentation/screens/home_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  Gemini.init(
    apiKey: dotenv.env['API_KEY'] ?? "",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final gemini = Gemini.instance;

    gemini
        .streamGenerateContent('Who is the pm of indian current ! ')
        .listen((value) {
      print(value.output);
    }).onError((e) {
      log('streamGenerateContent exception', error: e);
    });

    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(),
    );
  }
}

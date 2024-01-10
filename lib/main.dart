import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

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

    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: StreamBuilder(
            stream: gemini.streamGenerateContent(
                'top 10 most influncial persons in the world'),
            builder: (context, snapshot) {
              return Text(
                snapshot.data.toString(),
              );
            }),
      ),
    );
  }
}

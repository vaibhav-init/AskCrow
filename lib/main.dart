import 'package:ask_crow/features%20/history/presentation/history_view.dart';
import 'package:ask_crow/features%20/chat/presentation/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Ubuntu',
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: SafeArea(
          child: HomeView(),
        ),
      ),
      routes: {
        '/home': (context) => const HomeView(),
        '/history': (context) => const HistoryView(),
      },
    );
  }
}

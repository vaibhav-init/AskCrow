import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:voice_gpt/data/repository/chat_repository.dart';
import 'package:voice_gpt/presentation/screens/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    APIService.getData('who is virat kohli ');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          glowColor: Colors.purple,
          duration: const Duration(seconds: 2),
          animate: true,
          repeat: true,
          child: GestureDetector(
            onTapDown: (details) async {},
            onTapUp: (details) async {},
            child: const CircleAvatar(
              radius: 40,
              child: Icon(Icons.mic, color: Colors.white),
            ),
          ),
        ),
        body: const SafeArea(
          child: ApiPage(),
        ),
      ),
    );
  }
}

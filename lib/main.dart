import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:voice_gpt/common/loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          endRadius: 80,
          glowColor: Colors.purple,
          duration: const Duration(seconds: 2),
          animate: true,
          repeat: true,
          repeatPauseDuration: const Duration(milliseconds: 100),
          showTwoGlows: true,
          child: GestureDetector(
            onTapDown: (details) async {},
            onTapUp: (details) async {},
            child: const CircleAvatar(
              radius: 40,
              child: Icon(Icons.mic, color: Colors.white),
            ),
          ),
        ),
        body: SafeArea(
          child: ContentWidget(gemini: gemini),
        ),
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  final Gemini gemini;

  const ContentWidget({Key? key, required this.gemini}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ContentWidgetState createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  late Stream<dynamic> _stream;
  late List<dynamic> _dataList;
  late bool _isLoading;
  late String _errorMessage;

  @override
  void initState() {
    super.initState();
    _dataList = [];
    _isLoading = true;
    _errorMessage = '';
    _stream = widget.gemini
        .streamGenerateContent('top 10 most influential persons in the world');
    _stream.listen((data) {
      setState(() {
        _dataList.add(data); // Accumulate received data
        _isLoading = false;
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to fetch data: $error';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Loader();
    } else if (_errorMessage.isNotEmpty) {
      return const Loader();
    } else {
      return ListView.builder(
        itemCount: _dataList.length,
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              _dataList[index].toString(),
            ),
          );
        },
      );
    }
  }
}

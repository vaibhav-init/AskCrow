import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_gpt/common/loader.dart';
import 'package:voice_gpt/data/repository/chat_repository.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _messageController = TextEditingController();
  String result = '';
  bool isLoading = false;
  SpeechToText speechToText = SpeechToText();
  bool isListening = false;
  var textToShow = "Hold And Ask Your Question !";
  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(
      msg: "This is Center Short Toast",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              colorFilter: const ColorFilter.mode(
                Colors.green,
                BlendMode.srcIn,
              ),
              'assets/svgs/bot.svg',
              height: 35,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "AskCrow",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/history',
            ),
            icon: const Icon(
              Icons.history,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              textToShow,
              style: TextStyle(
                color: isListening ? Colors.black54 : Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 8,
                lightSource: LightSource.topLeft,
              ),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.7,
                child: !isLoading
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            result,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    : const Center(
                        child: Loader(),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        duration: const Duration(seconds: 2),
        animate: isListening,
        glowColor: Colors.lightGreen.withOpacity(0.2),
        repeat: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening) {
              var ava = await speechToText.initialize();
              if (ava) {
                setState(() {
                  isListening = true;

                  speechToText.listen(onResult: (result) {
                    setState(() {
                      textToShow = result.recognizedWords;
                    });
                  });
                });
              }
            }
          },
          onTapUp: (details) async {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
            _messageController.text = textToShow;
            if (_messageController.text != '') {
              setState(() {
                isLoading = true;
              });
              String message = _messageController.text;
              String result = await APIService.getData(message);

              setState(() {
                result = result;
                isLoading = false;
              });
            } else {
              // ignore: avoid_print
              print('Empty prompt !');
            }
          },
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.green,
            child: Icon(
              size: 30,
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

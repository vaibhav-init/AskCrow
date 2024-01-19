import 'package:ask_crow/common/loader.dart';
import 'package:ask_crow/models/question_model.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';
import '../../history/data/local_storage_api.dart';
import '../bloc/chat_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final SqliteService sqliteService = SqliteService();
  SpeechToText speechToText = SpeechToText();
  Future<void> addQuestion(String questionText) async {
    String uuid = const Uuid().v1();

    if (questionText.isNotEmpty) {
      QuestionModel newQuestion = QuestionModel(
        title: questionText,
        id: uuid,
      );
      await sqliteService.createQuestion(newQuestion);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      return buildUi(context, 'Tap, Hold And Speak :)', false, false, '');
    });
  }
}

Widget buildUi(BuildContext context, String textToShow, bool isListening,
    bool isLoading, String result) {
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
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
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
            // var ava = await speechToText.initialize();
            // if (ava) {}
          }
        },
        onTapUp: (details) async {
          // speechToText.stop();
          // _messageController.text = textToShow;
          // if (_messageController.text != '') {
          //   String message = _messageController.text;
          //   String response = await ChatDataProvider.getData(message);
          //   await addQuestion(textToShow);
          // } else {
          //   showToast('Enter some text man !');
          // }
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

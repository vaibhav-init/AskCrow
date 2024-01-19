// ignore_for_file: use_build_context_synchronously

import 'package:ask_crow/common/loader.dart';
import 'package:ask_crow/common/utils.dart';
import 'package:ask_crow/features%20/chat/bloc/chat_bloc.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../history/bloc/history_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  SpeechToText speechToText = SpeechToText();
  bool isListening = false;
  var textToShow = "Hold And Ask Your Question !";

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(ChatInit());
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return const Expanded(
                          child: Center(
                            child: Loader(),
                          ),
                        );
                      }
                      if (state is ChatError) {
                        return Center(
                          child: Text(
                            state.error,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }
                      if (state is! ChatFetched) {
                        return const Text('');
                      }
                      return SingleChildScrollView(
                        child: Text(
                          state.text,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                  ),
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
            context.read<ChatBloc>().add(
                  GetChatData(text: 'Who is Vaibhav Lakhera '),
                );
            setState(() {
              isListening = false;
            });
            speechToText.stop();

            if (textToShow != '') {
              String message = textToShow;
              context.read<ChatBloc>().add(
                    GetChatData(text: message),
                  );
              context
                  .read<HistoryBloc>()
                  .add(QuestionAdded(question: textToShow));
            } else {
              showToast('Enter some text man !');
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

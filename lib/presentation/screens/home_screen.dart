import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:voice_gpt/data/repository/chat_repository.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../models/chat_model.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  var textToShow = "Hold And Ask Your Question !";
  bool isListening = false;
  SpeechToText speechToText = SpeechToText();
  var scrollController = ScrollController();
  scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  final List<ChatMessage> messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 80,
        duration: const Duration(seconds: 2),
        glowColor: Colors.tealAccent,
        animate: isListening,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
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
            messages.add(
              ChatMessage(text: textToShow, type: ChatMessageType.user),
            );
            var msg = await ApiServiceForYou.sendMessage(textToShow);
            setState(() {
              messages.add(
                ChatMessage(text: msg, type: ChatMessageType.bot),
              );
              textToShow = "Hold And Ask Your Question !";
            });
          },
          child: CircleAvatar(
            backgroundColor: Colors.teal,
            radius: 40,
            child: Icon(isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Flutter X openAI',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              textToShow,
              style: TextStyle(
                color: isListening ? Colors.black54 : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      var chat = messages[index];
                      return messageBubble(
                          chatText: chat.text, type: chat.type);
                    }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Made with 💙 by Vaibhav Lakhera',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget messageBubble({
  required String? chatText,
  required ChatMessageType? type,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: CircleAvatar(
          backgroundColor: Colors.teal,
          child: type == ChatMessageType.user
              ? const Icon(
                  Icons.person_outlined,
                  size: 35,
                  color: Colors.black,
                )
              : SizedBox(
                  height: 35,
                  child: Image.network(
                      'https://cdn.iconscout.com/icon/premium/png-256-thumb/openai-1523664-1290202.png'),
                ),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          margin: const EdgeInsets.only(bottom: 5, right: 10, top: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          child: Text(
            chatText!,
            style: const TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    ],
  );
}

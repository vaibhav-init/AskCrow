import 'package:ask_crow/common/utils.dart';
import 'package:ask_crow/features%20/chat/data/data_provider/chat_data_provider.dart';

class ChatRepository {
  final ChatDataProvider chatDataProvider;
  final String message;

  ChatRepository({
    required this.chatDataProvider,
    required this.message,
  });

  Future<String> getChatData() async {
    String text = 'Error :(';
    try {
      text = await chatDataProvider.getData(message);
      return text;
    } catch (e) {
      showToast(e.toString());
    }
    return text;
  }
}

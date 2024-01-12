import 'package:ask_crow/common/utils.dart';
import 'package:ask_crow/features%20/chat/data/data_provider/chat_data_provider.dart';

class ChatRepository {
  final ChatDataProvider chatDataProvider;

  ChatRepository({
    required this.chatDataProvider,
  });

  Future<String> getChatData(String message) async {
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

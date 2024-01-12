import 'package:ask_crow/features%20/chat/data/repository/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final String message;

  ChatBloc(
    this.chatRepository,
    this.message,
  ) : super(ChatInitial()) {
    on<ChatFetched>(_getChatData);
  }

  void _getChatData(ChatFetched event, Emitter<ChatState> emit) {
    chatRepository.getChatData(message);
  }
}

// ignore_for_file: avoid_print

import 'package:ask_crow/features%20/chat/data/data_provider/chat_data_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatDataProvider chatDataProvider;
  ChatBloc(this.chatDataProvider) : super(ChatInitial()) {
    on<GetChatData>((event, emit) async {
      emit(ChatLoading());
      try {
        String message = await ChatDataProvider.getData(event.text);
        emit(
          ChatFetched(text: message),
        );
      } catch (e) {
        print(e);
      }
    });
    on<ChatInit>((event, emit) => emit(ChatInitial()));
  }
}

part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class GetChatData extends ChatEvent {
  final String text;

  GetChatData({required this.text});
}

class ChatInit extends ChatEvent {}

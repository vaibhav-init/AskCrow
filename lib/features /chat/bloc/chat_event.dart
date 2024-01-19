part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class ListenStart extends ChatEvent {}

class ListenEnd extends ChatEvent {}

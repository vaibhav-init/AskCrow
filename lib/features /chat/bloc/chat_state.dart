part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatFetched extends ChatState {
  final String text;

  ChatFetched({required this.text});
}

final class ChatLoading extends ChatState {}

final class ChatError extends ChatState {
  final String error;

  ChatError({required this.error});
}

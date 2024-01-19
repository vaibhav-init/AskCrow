part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ListeningStart extends ChatState {}

final class ListeningEnd extends ChatState {}

final class ChatError extends ChatState {
  final String error;

  ChatError({required this.error});
}

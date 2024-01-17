part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ListenStart extends ChatState {}

final class ListenEnd extends ChatState {}

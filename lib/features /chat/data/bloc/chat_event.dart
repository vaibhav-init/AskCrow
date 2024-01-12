part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class ChatFetched extends ChatEvent {}

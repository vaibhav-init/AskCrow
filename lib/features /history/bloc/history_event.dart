part of 'history_bloc.dart';

@immutable
sealed class HistoryEvent {}

class QuestionsLoaded extends HistoryEvent {}

class QuestionsDeleted extends HistoryEvent {}

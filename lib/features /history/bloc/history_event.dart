part of 'history_bloc.dart';

@immutable
sealed class HistoryEvent {}

class QuestionsLoaded extends HistoryEvent {}

class QuestionsDeleted extends HistoryEvent {}

class QuestionAdded extends HistoryEvent {
  final String question;

  QuestionAdded({required this.question});
}

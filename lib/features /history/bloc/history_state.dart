part of 'history_bloc.dart';

@immutable
sealed class HistoryState {}

final class HistoryInitial extends HistoryState {}

class HistoryLoadedState extends HistoryState {
  final List<QuestionModel> questions;

  HistoryLoadedState(this.questions);
}

class HistoryErrorState extends HistoryState {
  final String error;

  HistoryErrorState(this.error);
}

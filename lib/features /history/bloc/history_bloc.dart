import 'package:ask_crow/models/question_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../data/local_storage_api.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final SqliteService sqliteService;

  HistoryBloc(this.sqliteService) : super(HistoryInitial()) {
    on<QuestionsLoaded>(_loadQuestions);
    on<QuestionsDeleted>(_deleteAllQuestions);
    on<QuestionAdded>((event, emit) {
      _addQuestion(event.question);
    });
  }

  void _addQuestion(String questionText) async {
    String uuid = const Uuid().v1();

    if (questionText.isNotEmpty) {
      QuestionModel newQuestion = QuestionModel(
        title: questionText,
        id: uuid,
      );
      await sqliteService.createQuestion(newQuestion);
    }
  }

  void _loadQuestions(
    QuestionsLoaded state,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      List<QuestionModel> loadedQuestions = await sqliteService.getQuestions();
      emit(
        HistoryLoadedState(loadedQuestions),
      );
    } catch (e) {
      emit(
        HistoryErrorState(
          e.toString(),
        ),
      );
    }
  }

  void _deleteAllQuestions(
    QuestionsDeleted state,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      await sqliteService.deleteAllQuestions();
      emit(
        HistoryLoadedState(
          const [],
        ),
      );
    } catch (e) {
      emit(
        HistoryErrorState(
          e.toString(),
        ),
      );
    }
  }
}

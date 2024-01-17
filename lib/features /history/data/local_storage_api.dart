// ignore_for_file: avoid_print

import 'package:ask_crow/models/question_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteService {
  static const String tableName = 'question_list';

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'database1.db'),
      onCreate: (database, version) async {
        await database.execute(
          """CREATE TABLE $tableName(
           id TEXT PRIMARY KEY,  
           title TEXT NOT NULL
           )""",
        );
      },
      version: 1,
    );
  }

  Future<void> createQuestion(QuestionModel question) async {
    final Database db = await initializeDB();
    await db.insert(
      tableName,
      question.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QuestionModel>> getQuestions() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(tableName);
    return queryResult.map((e) => QuestionModel.fromMap(e)).toList();
  }

  Future<void> deleteAllQuestions() async {
    final db = await initializeDB();
    try {
      await db.delete(tableName);
    } catch (err) {
      print(err.toString());
    }
  }
}

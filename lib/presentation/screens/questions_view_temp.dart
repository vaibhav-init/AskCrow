// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_gpt/data/repository/local_storage_api.dart';
import 'package:voice_gpt/models/question_model.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final SqliteService sqliteService = SqliteService();
  final TextEditingController _questionController = TextEditingController();
  List<QuestionModel> questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> deleteAllQuestions() async {
    await sqliteService.deleteAllQuestions();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    List<QuestionModel> loadedQuestions = await sqliteService.getQuestions();
    setState(() {
      questions = loadedQuestions;
    });
  }

  Future<void> _addQuestion() async {
    String uuid = Uuid().v1();
    String questionText = _questionController.text.trim();
    if (questionText.isNotEmpty) {
      QuestionModel newQuestion = QuestionModel(
        title: questionText,
        id: uuid,
      );
      await sqliteService.createQuestion(newQuestion);
      _questionController.clear();
      _loadQuestions();
    }
  }

  Future<void> _deleteQuestion(String id) async {
    await sqliteService.deleteQuestion(id);
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              deleteAllQuestions();
            },
            child: const Text('Question Page')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Enter your question'),
              onSubmitted: (_) => _addQuestion(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addQuestion,
              child: Text('Add Question'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(questions[index].title),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteQuestion(questions[index].id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

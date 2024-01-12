// ignore_for_file: prefer_const_constructors

import 'package:ask_crow/common/utils.dart';
import 'package:ask_crow/data/repository/local_storage_api.dart';
import 'package:ask_crow/models/question_model.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  HistoryViewState createState() => HistoryViewState();
}

class HistoryViewState extends State<HistoryView> {
  final SqliteService sqliteService = SqliteService();
  List<QuestionModel> questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> deleteAllQuestions() async {
    await sqliteService.deleteAllQuestions();
    _loadQuestions();
    showToast('History Cleared!');
  }

  Future<void> _loadQuestions() async {
    List<QuestionModel> loadedQuestions = await sqliteService.getQuestions();
    setState(() {
      questions = loadedQuestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => deleteAllQuestions(),
            icon: const Icon(
              Icons.delete,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${index + 1}. ${questions[index].title}'),
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

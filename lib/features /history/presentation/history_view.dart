import 'package:ask_crow/features%20/history/bloc/history_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  HistoryViewState createState() => HistoryViewState();
}

class HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(QuestionsLoaded());
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
            onPressed: () =>
                context.read<HistoryBloc>().add(QuestionsDeleted()),
            icon: const Icon(
              Icons.delete,
            ),
          )
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryErrorState) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          }
          if (state is! HistoryLoadedState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.questions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            '${index + 1}. ${state.questions[index].title}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

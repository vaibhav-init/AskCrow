import 'package:ask_crow/features%20/chat/bloc/chat_bloc.dart';
import 'package:ask_crow/features%20/chat/data/data_provider/chat_data_provider.dart';
import 'package:ask_crow/features%20/history/bloc/history_bloc.dart';
import 'package:ask_crow/features%20/history/data/local_storage_api.dart';
import 'package:ask_crow/features%20/history/presentation/history_view.dart';
import 'package:ask_crow/features%20/chat/presentation/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SqliteService>(
          create: (context) => SqliteService(),
        ),
        RepositoryProvider<ChatDataProvider>(
          create: (context) => ChatDataProvider(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HistoryBloc>(
            create: (BuildContext context) =>
                HistoryBloc(context.read<SqliteService>()),
          ),
          BlocProvider<ChatBloc>(
            create: (BuildContext context) =>
                ChatBloc(context.read<ChatDataProvider>()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Ubuntu',
            useMaterial3: true,
          ),
          home: const Scaffold(
            body: SafeArea(
              child: HomeView(),
            ),
          ),
          routes: {
            '/home': (context) => const HomeView(),
            '/history': (context) => const HistoryView(),
          },
        ),
      ),
    );
  }
}

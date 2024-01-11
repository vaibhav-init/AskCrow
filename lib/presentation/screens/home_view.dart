import 'package:flutter/material.dart';
import 'package:voice_gpt/data/repository/chat_repository.dart';

class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ApiPageState createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  final TextEditingController _messageController = TextEditingController();
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Enter your message',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String message = _messageController.text;
                  String result = await APIService.getData(message);
                  setState(() {
                    _result = result;
                  });
                },
                child: const Text('Generate Content'),
              ),
              const SizedBox(height: 20),
              Text(
                'Generated Content: $_result',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

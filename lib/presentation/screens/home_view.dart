import 'package:neumorphic_ui/neumorphic_ui.dart';
import 'package:voice_gpt/common/loader.dart';
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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 8,
                lightSource: LightSource.topLeft,
              ),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.7,
                child: !isLoading
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _result,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    : const Center(
                        child: Loader(),
                      ),
              ),
            ),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Enter your message',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_messageController.text != '') {
                  setState(() {
                    isLoading = true;
                  });
                  String message = _messageController.text;
                  String result = await APIService.getData(message);
                  setState(() {
                    _result = result;
                    isLoading = false;
                  });
                } else {
                  // ignore: avoid_print
                  print('Empty prompt !');
                }
              },
              child: const Text('Generate Content'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

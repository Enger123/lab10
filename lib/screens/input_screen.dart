import 'package:flutter/material.dart';
import 'preview_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  double _fontSize = 16;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Image.asset(
          'assets/images/robot.webp',
          width: 56,
          height: 56,
        ),
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _openPreview() async {
    if (!_formKey.currentState!.validate()) return;

    // true = Ok, false = Cancel, null = повернулися без натискання кнопок
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          text: _textController.text,
          fontSize: _fontSize,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      _showMessage('Cool!');
    } else if (result == false) {
      _showMessage('Let’s try something else');
    } else {
      _showMessage('Don\'t know what to say');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text previewer')),
      body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Text',
                  helperText: 'Enter some text',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Font size: ${_fontSize.round()}'),
                  Expanded(
                    child: Slider(
                      value: _fontSize,
                      min: 1,
                      max: 100,
                      divisions: 99,
                      onChanged: (value) {
                        setState(() => _fontSize = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: FilledButton(
                  onPressed: _openPreview,
                  child: const Text('Preview'),
                ),
              ),
            ],
          ),
        ),
      )
      ),
    );

  }
}
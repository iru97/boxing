import 'package:flutter/material.dart';

class SessionEditorScreen extends StatelessWidget {
  final String? sessionId;

  const SessionEditorScreen({super.key, this.sessionId});

  @override
  Widget build(BuildContext context) {
    final isEditing = sessionId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Session' : 'New Session'),
        actions: [
          TextButton(
            onPressed: () {
              // Save will be implemented in Sprint 3
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: const Center(
        child: Text('Session editor coming in Sprint 3'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AddProjectScreen extends StatelessWidget {
  final Function(String title, String description, String date) onAddProject;

  const AddProjectScreen({Key? key, required this.onAddProject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final dateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Project Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;
                final date = dateController.text;
                onAddProject(title, description, date);
                Navigator.pop(context);
              },
              child: const Text('Add Project'),
            ),
          ],
        ),
      ),
    );
  }
}

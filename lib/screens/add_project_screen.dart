import 'package:flutter/material.dart';

class AddProjectScreen extends StatefulWidget {
  final Function(String title, String description, String date) onAddProject;

  const AddProjectScreen({super.key, required this.onAddProject});

  @override
  // ignore: library_private_types_in_public_api
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();

  String? titleError;
  String? descriptionError;
  String? dateError;

  void _showDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  bool _validateInputs() {
    setState(() {
      titleError = titleController.text.isEmpty ? 'Title is required' : null;
      descriptionError =
          descriptionController.text.isEmpty ? 'Description is required' : null;
      dateError = dateController.text.isEmpty ? 'Date is required' : null;
    });

    return titleError == null && descriptionError == null && dateError == null;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: InputDecoration(
                labelText: 'Project Title',
                errorText: titleError,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                errorText: descriptionError,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Start Date',
                errorText: dateError,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _showDatePicker,
                ),
              ),
              onTap: _showDatePicker,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_validateInputs()) {
                  widget.onAddProject(
                    titleController.text,
                    descriptionController.text,
                    dateController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Project'),
            ),
          ],
        ),
      ),
    );
  }
}

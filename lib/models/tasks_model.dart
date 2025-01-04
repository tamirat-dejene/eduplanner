import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

enum TaskStatus { pending, newtask, completed }

class TaskModel {
  final String title;
  final String description;
  final String date;
  final String time;
  final TaskStatus status;

  TaskModel({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.status,
  });
  static Future<List<TaskModel>> getTasks(TaskStatus status) async {
    final String response = await rootBundle.loadString('assets/tasks.json');
    final data = await json.decode(response) as List<dynamic>;
    List<TaskModel> tasks = data
        .map((task) => TaskModel(
              title: task['title'],
              description: task['description'],
              date: task['date'],
              time: task['time'],
              status: task['status'],
            ))
        .toList();

    return tasks.where((task) => task.status == status).toList();
  }
}

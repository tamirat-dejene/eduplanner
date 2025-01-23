import 'package:edu_planner/models/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final List<Map<String, dynamic>> reminders = [];
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadReminders();
  }

  void _initializeNotifications() async {
    tz.initializeTimeZones();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: androidSettings);
    await notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(String title, DateTime dateTime) async {
    final androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    final platformDetails = NotificationDetails(android: androidDetails);
    final tzDateTime = tz.TZDateTime.from(dateTime, tz.local);
    await notificationsPlugin.zonedSchedule(
      dateTime.millisecondsSinceEpoch.hashCode,
      title,
      'Reminder for $title',
      tzDateTime,
      platformDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _loadReminders() async {
    final dbReminders = await dbHelper.fetchReminders();
    setState(() {
      reminders.clear();
      reminders.addAll(dbReminders);
    });
  }

  void _addReminder(Map<String, dynamic> reminder, DateTime dateTime) {
    dbHelper.addReminder(reminder).then((id) {
      if (id > 0) {
        _scheduleNotification(reminder['title'], dateTime);
        _loadReminders();
      }
    });
  }

  void _removeReminder(id) {
    dbHelper.deleteReminder(id).then((rowsDeleted) {
      if (rowsDeleted > 0) {
        notificationsPlugin.cancel(id);
        _loadReminders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const SizedBox(
            width: double.infinity,
            child: Text(
              'My Reminders',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: reminders.isEmpty
                ? Text(
                    'No reminders available. Tap the "+" button to add a reminder!',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = reminders[index];
                      return Card(
                        child: ListTile(
                          title: Text(reminder['title']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (reminder['description'] != null &&
                                  reminder['description']!.isNotEmpty)
                                Text(reminder['description']),
                              Text('Time: ${reminder['dateTime']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeReminder(reminder['id']),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Reminder'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Description (Optional)'),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date & Time'),
                  readOnly: true,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      final pickedTime = await showTimePicker(
                        // ignore: use_build_context_synchronously
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        final selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        dateController.text = DateFormat('yyyy-MM-dd HH:mm')
                            .format(selectedDateTime);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;
                final date = dateController.text;

                if (title.isEmpty || date.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Title and Date & Time are required'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final parsedDateTime =
                    DateFormat('yyyy-MM-dd HH:mm').parse(date);

                _addReminder({
                  'title': title,
                  'description': description,
                  'dateTime': date,
                }, parsedDateTime);

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

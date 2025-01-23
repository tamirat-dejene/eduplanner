import 'package:edu_planner/models/database_helper.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Map<String, dynamic>> schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final dbSchedules = await DatabaseHelper().fetchSchedules();
    setState(() {
      schedules = dbSchedules;
    });
  }

  void _addSchedule(Map<String, dynamic> schedule) async {
    final id = await DatabaseHelper().addSchedule(
      schedule['courseName'],
      schedule['classRoom'],
      schedule['time'],
      schedule['date'],
    );

    if (id > 0) _loadSchedules();
  }

  void _removeSchedule(int id) async {
    final rowsDeleted = await DatabaseHelper().deleteSchedule(id);
    if (rowsDeleted > 0) _loadSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: const Text(
              'My Schedules',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 8),
          schedules.isEmpty
              ? const Text(
                  'No schedules available. Tap the "+" button to add a schedule!',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];
                    return Card(
                      child: ListTile(
                        title: Text(schedule['courseName']),
                        subtitle: Text(
                          'Classroom: ${schedule['classRoom']}, Time: ${schedule['time']}, Date: ${schedule['date']}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeSchedule(schedule['id']),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddScheduleDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddScheduleDialog(BuildContext context) {
    final courseNameController = TextEditingController();
    final classRoomController = TextEditingController();
    final timeController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Schedule'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: courseNameController,
                  decoration: const InputDecoration(labelText: 'Course Name'),
                ),
                TextField(
                  controller: classRoomController,
                  decoration: const InputDecoration(labelText: 'Classroom'),
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                  onTap: () async {
                    final timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (timeOfDay != null) {
                      // ignore: use_build_context_synchronously
                      timeController.text = timeOfDay.format(context);
                    }
                  },
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      dateController.text =
                          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
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
                final courseName = courseNameController.text;
                final classRoom = classRoomController.text;
                final time = timeController.text;
                final date = dateController.text;

                if (courseName.isNotEmpty &&
                    classRoom.isNotEmpty &&
                    time.isNotEmpty &&
                    date.isNotEmpty) {
                  _addSchedule({
                    'courseName': courseName,
                    'classRoom': classRoom,
                    'time': time,
                    'date': date,
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

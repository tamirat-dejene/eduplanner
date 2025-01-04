import 'package:flutter/material.dart';
import '../widgets/project_card.dart';

class TaskTabView extends StatefulWidget {
  const TaskTabView({Key? key}) : super(key: key);

  @override
  _TaskTabViewState createState() => _TaskTabViewState();
}

class _TaskTabViewState extends State<TaskTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, String>> pendingProjects = [
    {
      'projectName': 'Project A',
      'description': 'Pending Task 1',
      'date': 'June 15, 2022'
    },
    {
      'projectName': 'Project B',
      'description': 'Pending Task 2',
      'date': 'June 17, 2022'
    },
  ];

  List<Map<String, String>> newProjects = [
    {
      'projectName': 'Project C',
      'description': 'New Task 1',
      'date': 'July 1, 2022'
    },
    {
      'projectName': 'Project D',
      'description': 'New Task 2',
      'date': 'July 3, 2022'
    },
  ];

  List<Map<String, String>> finishedProjects = [
    {
      'projectName': 'Project E',
      'description': 'Finished Task 1',
      'date': 'May 20, 2022'
    },
    {
      'projectName': 'Project F',
      'description': 'Finished Task 2',
      'date': 'May 22, 2022'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void moveToPending(Map<String, String> project) {
    setState(() {
      newProjects.remove(project);
      pendingProjects.add(project);
    });
  }

  void moveToFinished(Map<String, String> project) {
    setState(() {
      pendingProjects.remove(project);
      finishedProjects.add(project);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              tabs: const [
                Tab(icon: Icon(Icons.pending), text: 'Pending'),
                Tab(icon: Icon(Icons.new_releases), text: 'New'),
                Tab(icon: Icon(Icons.done), text: 'Finished'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProjectList(pendingProjects, moveToFinished),
                  _buildProjectList(newProjects, moveToPending),
                  _buildProjectList(finishedProjects, null),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              // Handle adding a new project here
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectList(
    List<Map<String, String>> projects,
    void Function(Map<String, String>)? onCheckboxToggle,
  ) {
    if (projects.isEmpty) {
      return const Center(
        child: Text('No projects available'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Column(
          children: [
            ProjectCard(
              projectName: project['projectName']!,
              description: project['description']!,
              date: project['date']!,
              onMarkDone: onCheckboxToggle != null
                  ? (bool? value) {
                      if (value == true) onCheckboxToggle(project);
                    }
                  : null,
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

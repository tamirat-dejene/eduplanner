import 'package:edu_planner/models/database_helper.dart';
import 'package:edu_planner/screens/add_project_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/project_card.dart';

class HomeTaskTab extends StatefulWidget {
  const HomeTaskTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeTaskTabState createState() => _HomeTaskTabState();
}

class _HomeTaskTabState extends State<HomeTaskTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Map<String, dynamic>> pendingProjects = [];
  List<Map<String, dynamic>> newProjects = [];
  List<Map<String, dynamic>> finishedProjects = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final pending = await _dbHelper.fetchProjectsByStatus('pending');
    final newProjects = await _dbHelper.fetchProjectsByStatus('new');
    final finished = await _dbHelper.fetchProjectsByStatus('finished');

    setState(() {
      pendingProjects = pending;
      this.newProjects = newProjects;
      finishedProjects = finished;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void moveProjects(List<Map<String, dynamic>> froP,
      List<Map<String, dynamic>> toP, Map<String, dynamic> project) async {
    final newStatus = toP == pendingProjects
        ? 'pending'
        : (toP == finishedProjects ? 'finished' : 'new');
    await _dbHelper.updateProjectStatus(project['id'], newStatus);
    _loadProjects();
  }

  void removeProject(int id) async {
    await _dbHelper.deleteProject(id);
    _loadProjects();
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
                  _buildProjectList(pendingProjects),
                  _buildProjectList(newProjects),
                  _buildProjectList(finishedProjects),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProjectScreen(
                    onAddProject: (title, description, date) async {
                      await _dbHelper.addProject(
                          title, description, date, 'new');
                      _loadProjects();
                    },
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectList(List<Map<String, dynamic>> projects) {
    if (projects.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          projects == newProjects
              ? 'No new projects yet. Add one by tapping the + button below!'
              : (projects == pendingProjects
                  ? 'No pending projects yet. Start one!'
                  : 'No finished projects yet. Keep going!'),
          textAlign: TextAlign.left,
        ),
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
                actionLabel: projects == newProjects
                    ? "Start?"
                    : (projects == pendingProjects ? "Done?" : null),
                onRemoveProject: () => removeProject(project['id']),
                onMoveProject: () => moveProjects(
                    projects,
                    projects == newProjects
                        ? pendingProjects
                        : (projects == pendingProjects ? finishedProjects : []),
                    project)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String projectName;
  final String description;
  final String date;
  final String? actionLabel;
  final VoidCallback onRemoveProject;
  final VoidCallback? onMoveProject;

  const ProjectCard({
    super.key,
    required this.projectName,
    required this.description,
    required this.date,
    required this.onRemoveProject,
    this.actionLabel,
    this.onMoveProject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  projectName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_forever_outlined),
                color: const Color.fromARGB(255, 236, 77, 77),
                onPressed: onRemoveProject,
              ),
              if (onMoveProject != null && actionLabel != null)
                Row(
                  children: [
                    Text(
                      actionLabel!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_box_outline_blank),
                      color: Colors.white,
                      onPressed: onMoveProject,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

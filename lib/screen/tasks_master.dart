import 'dart:math';

import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import '../models/task.dart';

class TasksMaster extends StatefulWidget {
  const TasksMaster({super.key});

  @override
  State<TasksMaster> createState() => _TasksMasterState();
}

class _TasksMasterState extends State<TasksMaster> {
  Future<List<Task>> _fetchTasks() {
    List<Task> tasks = <Task>[];
    Faker faker = new Faker();
    final randomNumberGenerator = Random();
    for (int i = 0; i < 100; i++) {
      tasks.add(Task(
          content: faker.lorem.sentence(),
          completed: randomNumberGenerator.nextBool()));
    }

    return Future.delayed(Duration(seconds: 2), () => tasks);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Une erreur s\'est produite'));
          } else {
            final tasks = snapshot.data;

            return ListView.separated(
              itemCount: tasks!.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
                thickness: 1,
                indent: 30,
                endIndent: 30,
              ),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskPreview(
                  task: task,
                );
              },
            );
          }
        });
  }
}

class TaskPreview extends StatelessWidget {
  final Task task;

  const TaskPreview({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final icon =
        task.completed ? Icons.check_circle : Icons.radio_button_unchecked;
    return ListTile(
      leading: Icon(icon),
      title: Text(task.title),
      subtitle: Text(task.content),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:todo_list_v1/screen/task_details.dart';
import '../models/task.dart';
import 'ask_form.dart';

class TasksMaster extends StatefulWidget {
  const TasksMaster({super.key});

  @override
  State<TasksMaster> createState() => _TasksMasterState();
}

class _TasksMasterState extends State<TasksMaster>
  {

  late List<Task> _tasks;
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _fetchTasks();
  }

  Future<List<Task>> _fetchTasks() async {
    List<Task> tasks = [];
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
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Une erreur s\'est produite'));
          } else {
            _tasks = snapshot.data as List<Task>;
            return Scaffold(
                body: ListView.separated(
                itemCount: _tasks!.length,
                separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                      thickness: 1,
                      indent: 30,
                      endIndent: 30,
                    ),
                itemBuilder: (context, index) {
                  return TaskPreview(
                    task: _tasks[index],
                    onTap: () async {
                      var result = await Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) =>
                              TaskDetails(task: _tasks[index]),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _tasks[index] =
                              result; // Remplace la tâche par la tâche mise à jour.
                        });
                      }
                    },
                  );
                }
                ),
              floatingActionButton: FloatingActionButton(
                onPressed:  () async {
                  var result = await Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (_, __, ___) =>
                          TaskForm(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _tasks.insert(0, result); // Remplace la tâche par la tâche mise à jour.
                    });
                  }
                },
                child: const Icon(Icons.add),
              ),
            );
          }
        });
  }
}

class TaskPreview extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskPreview({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final icon =
        task.completed ? Icons.check_circle : Icons.radio_button_unchecked;
    return ListTile(
      leading: Icon(icon),
      title: Text(task.title),
      subtitle: Text(task.content),
      onTap: onTap,
    );
  }
}

/*
class Pseudo3dRouteBuilder extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  Pseudo3dRouteBuilder(this.exitPage, this.enterPage)
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => enterPage,
    transitionsBuilder: _transitionsBuilder(exitPage, enterPage),
  );

  static _transitionsBuilder(exitPage, enterPage) =>
          (context, animation, secondaryAnimation, child) {
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: Offset(-1.0, 0.0),
              ).animate(animation),
              child: Container(
                color: Colors.white,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.003)
                    ..rotateY(pi / 2 * animation.value),
                  alignment: FractionalOffset.centerRight,
                  child: exitPage,
                ),
              ),
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: Container(
                color: Colors.white,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.003)
                    ..rotateY(pi / 2 * (animation.value - 1)),
                  alignment: FractionalOffset.centerLeft,
                  child: enterPage,
                ),
              ),
            )
          ],
        );
      };
}
 */

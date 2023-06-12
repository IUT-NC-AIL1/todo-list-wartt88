import 'dart:math';

import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_v1/providers/tasks_provider.dart';
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

  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = context.read<TasksProvider>().readData(context); //_fetchTasks();
  }

  /*
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
   */

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksProvider>(context);

    return FutureBuilder(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            //return Center(child: Text('Une erreur s\'est produite'));
            return Center(child: Text(snapshot.error.toString()));
          } else {
            //_tasks = snapshot.data as List<Task>;
            return Scaffold(
                backgroundColor: Color(0xFFD4D4D4),
                body: Consumer<TasksProvider>(
                builder: (context,tasksProvider,child) {
                  return ListView.separated(
                      itemCount: tasksProvider
                          .getTasks()
                          .length,
                      separatorBuilder: (context, index) =>
                          Divider(
                              color: Color(0xFF182c4d),
                              thickness: 1,
                              indent: 30,
                              endIndent: 30,
                            ),
                      itemBuilder: (context, index) {
                        return TaskPreview(
                          task: tasksProvider.getTasks()[index],
                          onTap: () async {
                            var result = await Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder: (_, __, ___) =>
                                    TaskDetails(
                                        task: tasksProvider.getTasks()[index]),
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
                              tasksProvider.updateData(result);
                            }
                          },
                        );
                      }
                  );
                },
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
                      //ajoute la nouvelle tache
                    tasksProvider.addData(result, context);
                      //_tasks.insert(0, result);
                  }
                },
                backgroundColor: Color(0xFF182c4d),
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

    String remplacement = task.content.replaceAll('\n', '...\n');

    return
      Dismissible(
        key: Key('${task.id.toString()}'),
        background: Container(
          color: Color(0xFFCA0303),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirmation"),
                content: Text("Voulez-vous vraiment supprimer cette tâche?"),
                actions: <Widget>[
                  TextButton(
                    child: Text("Oui"),
                    onPressed: () {
                      Provider.of<TasksProvider>(context,listen: false).deleteData(task);
                      Navigator.of(context).pop(true);
                    },
                  ),
                  TextButton(
                    child: Text("Non"),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: ListTile(
          leading: Icon(icon),
          title: Text(task.title),
          subtitle: Text(
            remplacement,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: onTap,
        ),
      );



  }
}

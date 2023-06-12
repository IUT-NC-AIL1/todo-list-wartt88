import 'package:flutter/material.dart';
import 'package:todo_list_v1/screen/tasks_master.dart';

class ToDoListApp extends StatefulWidget {
  const ToDoListApp({super.key});

  @override
  State<ToDoListApp> createState() => _ToDoListAppState();
}

class _ToDoListAppState extends State<ToDoListApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(
        primaryColor: Color(0xFF335d9f),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF335d9f),
          shadowColor: Color(0xFF485862),
          title: const Text('ToDo List'),
        ),
        backgroundColor: Color(0xFFD4D4D4),
        body: const TasksMaster(),
      ),
    );
  }
}

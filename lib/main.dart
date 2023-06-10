import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_list_v1/providers/tasks_provider.dart';
import 'todo_list_app.dart';

Future<void> main() async{
  await Supabase.initialize(
      url: 'https://tggwxydzenqagiabfnuh.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRnZ3d4eWR6ZW5xYWdpYWJmbnVoIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODYxMjM0NDIsImV4cCI6MjAwMTY5OTQ0Mn0.I6pXyFAekuamCUZrwm_kyTsWZd6JrBzArzMr83AXQA4');
  runApp(ChangeNotifierProvider(create: (context) => TasksProvider(), child:const ToDoListApp()));
}

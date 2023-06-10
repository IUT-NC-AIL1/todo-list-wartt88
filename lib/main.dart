import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_list_v1/providers/tasks_provider.dart';
import 'todo_list_app.dart';

Future<void> main() async{
  await dotenv.load(fileName: "assets/.env");
  String url = dotenv.env['SUPABASE_URL']!;
  String anonKey = dotenv.env['SUPABASE_API_KEY']!;
  await Supabase.initialize(
      url: url,
      anonKey: anonKey);
  runApp(ChangeNotifierProvider(create: (context) => TasksProvider(), child:const ToDoListApp()));
}

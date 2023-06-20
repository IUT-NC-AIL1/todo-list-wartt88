import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_list_v1/models/task.dart';
import 'package:flutter/material.dart';

class TasksProvider extends ChangeNotifier{

  late List<Task> _tasks = [];

  Future<List<Task>> readData(context) async {
    // var response = await client.from("todotable").select().order('task', ascending: true).execute();
    print('Read Data');
    try {
      var response = await Supabase.instance.client.from('todotable').select();
      if(response is List<dynamic>) {
        _tasks = response.map((task) {
          Task t = Task(
              content: task['content'],
              completed: task['completed']
          );
          t.id=task['id'];
          t.title=task['title'];
          return t;
        }).toList();
      }else {
    throw Exception('format de réponse incorrect');
    }
      notifyListeners();
      return _tasks;
    } catch (e) {
      print('Response Error ${e}');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Erreur d\'accès à la Base de données'),
        backgroundColor: Colors.red,
      ));
      notifyListeners();
      return [];
    }
  }

  updateData(Task t) async {
    await Supabase.instance.client
        .from('todotable')
        .upsert({ 'id': t.id, 'title': t.title, 'content': t.content, 'completed': t.completed});

    // modification en local de _tasks
    final taskIndex = _tasks.indexWhere((task) => task.id == t.id);
    if(taskIndex != -1){
      _tasks[taskIndex] = t;
    } else {
      _tasks.add(t);
    }

    notifyListeners();
    //je suppose qu un seul utilisateur modifie la bdd et donc je ne suis pas oblig" de rappeler readData sur _tasks
  }

  deleteData(Task t) async {
    await Supabase.instance.client
        .from('todotable')
        .delete()
        .match({ 'id': t.id });

    // modification en local de _tasks
    _tasks.removeWhere((task) => task.id == t.id);

    notifyListeners();
  }

  addData(Task t, context) async {
    try {
      final response = await Supabase.instance.client
          .from('todotable')
          .upsert({'title': t.title, 'content': t.content, 'completed': t.completed});

      // Récupérer l'ID attribué en faisant une requête de recherche
      final selectResponse = await Supabase.instance.client
          .from('todotable')
          .select('id')
          .eq('title', t.title)
          .single();

      print(selectResponse['id']);
      if (selectResponse != null) {
        final taskId = selectResponse['id'] as int;
        t.id = taskId;
      }

      _tasks.insert(0, t);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('tâche ajoutée'),
      ));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Erreur pour l\'ajout de la nouvelle tâche'),
        backgroundColor: Colors.red,
      ));
    }
    notifyListeners();

  }

  List<Task> getTasks(){
    return _tasks;
  }

}
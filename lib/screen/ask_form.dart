import 'package:flutter/material.dart';
import 'package:todo_list_v1/models/task.dart';
import 'package:todo_list_v1/screen/tasks_master.dart';

// Define a custom Form widget.
class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  TaskFormState createState() {
    return TaskFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class TaskFormState extends State<TaskForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _taskNameController = TextEditingController();
    final _taskContentController = TextEditingController();
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Titre',
                ),
                controller: _taskNameController,
              ),
              const SizedBox(height: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Contenu'),
                        SizedBox(height: 8.0),
                        Container(
                          constraints: BoxConstraints(maxHeight: 200.0),
                          // Définir une limite de hauteur
                          child: SingleChildScrollView(
                            child: TextFormField(
                              controller: _taskContentController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Champ obligatoire';
                                }
                                return null;
                              },
                              maxLines: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tâche ajoutée')),
                    );
                    Task t = Task(
                        content: _taskContentController.text,
                        completed: false);
                    String name = _taskNameController.text;
                    if (name != "" && name != null) {
                      t.title = name;
                    }
                    Navigator.pop(context, t);
                  }
                },
                child: Text('Ajouter'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

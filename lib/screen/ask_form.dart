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

class TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _taskNameController = TextEditingController();
    final _taskContentController = TextEditingController();
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF335d9f),
        title: Text('Ajouter'),
      ),
      backgroundColor: Color(0xFFD4D4D4),
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
                        SizedBox(height: 8.0),
                        Container(
                          constraints: BoxConstraints(maxHeight: 200.0),
                          // Définir une limite de hauteur
                          child: SingleChildScrollView(
                            child: TextFormField(
                              controller: _taskContentController,
                              decoration: InputDecoration(
                                labelText: 'Contenu',
                              ),
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF335d9f)),
                ),
                child: Text('Ajouter'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

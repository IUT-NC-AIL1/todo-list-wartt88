import 'package:flutter/material.dart';
import 'package:todo_list_v1/screen/tasks_master.dart';

import '../models/task.dart';

class TaskDetails extends StatefulWidget {
  final Task task;

  const TaskDetails({super.key, required this.task});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  bool _isCompleted = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _contentController = TextEditingController(text: widget.task.content);
    _isCompleted = widget.task.completed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Modifier'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Titre',
                  ),
                ),
                SizedBox(height: 16.0),
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
                            controller: _contentController,
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
                      CheckboxListTile(
                        title: Text(": completed"),
                        value: _isCompleted,
                        onChanged: (value) {
                          setState(() {
                            _isCompleted = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  ),
                ),
                //SizedBox(width: 16.0),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tâche modifiée')),
                      );
                      widget.task.completed = _isCompleted;
                      widget.task.title = _titleController.text;
                      widget.task.content = _contentController.text;
                      Navigator.pop(context, widget.task);
                    }
                  },
                  child: Text('Enregistrer'),
                )
              ],
            ),
          ),
        ));
  }
}

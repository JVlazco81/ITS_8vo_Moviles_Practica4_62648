import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskScreen extends StatefulWidget {
  final Task? task;

  const TaskScreen({super.key, this.task});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.titulo;
      _descriptionController.text = widget.task!.descripcion;
      _isCompleted = widget.task!.completada;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Agregar tarea' : 'Editar tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: null,
            ),
            CheckboxListTile(
              title: const Text('Completada'),
              value: _isCompleted,
              onChanged: (value) {
                setState(() {
                  _isCompleted = value ?? false;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El título es obligatorio')),
                  );
                  return;
                }

                final task = Task(
                  id: widget.task?.id ?? 0,
                  titulo: _titleController.text,
                  descripcion: _descriptionController.text,
                  completada: _isCompleted,
                );

                Navigator.pop(context, task);
              },
              child: Text(widget.task == null ? 'Guardar' : 'Actualizar'),
            )
          ],
        ),
      ),
    );
  }
}
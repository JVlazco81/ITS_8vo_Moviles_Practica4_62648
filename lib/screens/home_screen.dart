import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../screens/task_screen.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await AuthService.logout();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sesión cerrada con éxito')),
                );
                await Future.delayed(const Duration(milliseconds: 500));
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No hay tareas pendientes'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      task.titulo,
                      style: TextStyle(
                        decoration: task.completada
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(task.descripcion),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final updatedTask = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskScreen(task: task),
                              ),
                            );
                            if (updatedTask != null) {
                              try {
                                await taskProvider.addOrUpdateTask(updatedTask);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error al actualizar la tarea: $e')),
                                );
                              }
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(task.completada
                              ? Icons.check_circle
                              : Icons.check_circle_outline),
                          onPressed: () async {
                            try {
                              await taskProvider.toggleCompletion(task.id, !task.completada);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error al cambiar el estado: $e')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              await taskProvider.deleteTask(task.id);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error al eliminar la tarea: $e')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskScreen()),
          );
          if (newTask != null) {
            try {
              await taskProvider.addOrUpdateTask(newTask);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al crear la tarea: $e')),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
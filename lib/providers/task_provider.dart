import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    try {
      final data = await ApiService.getTasks();
      _tasks = data.map((t) => Task.fromJson(t)).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addOrUpdateTask(Task task) async {
    try {
      if (task.id == 0) {
        await ApiService.createTask(task.toJson());
      } else {
        await ApiService.updateTask(task.id, task.toJson());
      }
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await ApiService.deleteTask(id);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleCompletion(int id, bool completed) async {
    try {
      await ApiService.toggleTaskCompletion(id, completed);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }
}

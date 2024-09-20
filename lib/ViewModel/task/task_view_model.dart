import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/model/task/add_task_model.dart';
import 'package:todo_list_app/model/task/task_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:todo_list_app/shared/url_api.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TaskViewModel extends ChangeNotifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TaskViewModel() {
    _initializeNotifications();
  }
  void _initializeNotifications() {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  void scheduleTaskNotification(Task task) {
    final scheduledDate = tz.TZDateTime.from(task.dueDate, tz.local);

    flutterLocalNotificationsPlugin.zonedSchedule(
      task.id,
      'Task Reminder',
      'Task "${task.title}" is due!',
      scheduledDate,
      const NotificationDetails(
        android:
            AndroidNotificationDetails('task_reminder_channel', 'TaskChannel'),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  List<Task> tasks = [];
  bool isLoading = false;
  int currentPage = 1;
  bool hasMoreData = true;
  final int itemsPerPage = 10;

  // Para manejar filtros
  String filter = "all"; // other options: "completed", "pending"

  Future<void> fetchTasks() async {
    try {
      if (!hasMoreData || isLoading) return;
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No token found');
      }

      final url =
          Uri.parse('${urlApi}tasks?page=$currentPage'); // Add pagination
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        List<Task> fetchedTasks = (responseData['data']['tasks'] as List)
            .map((taskJson) => Task.fromJson(taskJson))
            .toList();

        tasks.addAll(fetchedTasks);
        currentPage++;
        hasMoreData = fetchedTasks.length ==
            itemsPerPage; // Update hasMoreData based on response
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      // Here, you might want to show a Snackbar or other UI feedback
    } finally {
      isLoading = false;
      // Use Future.delayed to avoid conflicts
      Future.delayed(Duration.zero, () {
        notifyListeners();
      });
    }
  }

  Future<void> addTask(TaskInsert newTask) async {
    // Assuming you have a method to save the task via your API
    final url = Uri.parse('${urlApi}tasks');

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(newTask.toJson()), // Convert your Task to JSON
      );

      if (response.statusCode == 201) {
        // Assuming 201 is returned on successful creation
        final responseData = json.decode(response.body);
        newTask.order = 0;
        Task createdTask = Task.fromJson(responseData['data']);
        tasks.add(createdTask); // Add the new task to the list
        notifyListeners(); // Notify listeners of the change
      } else {
        throw Exception('Failed to add task');
      }
    } catch (e) {
      print('Error adding task: $e');
      // Handle error (e.g., show a message to the user)
    }
  }

  // pending", "completed", "progress"
  // Filtrar tareas
  List<Task> get filteredTasks {
    switch (filter) {
      case 'completed':
        return tasks
            .where((task) => task.status == 'completed')
            .toList(); // Ejemplo
      case 'pending':
        return tasks.where((task) => task.status == 'pending').toList();
      case 'progress':
        return tasks.where((task) => task.status == 'progress').toList();
      default:
        return tasks;
    }
  }

  // Drag and Drop funcionalidad
  void reorderTasks(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1; // Ajustar si se está moviendo hacia abajo
    }
    final Task task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);
    notifyListeners(); // Notifica a los oyentes sobre el cambio
  }
}

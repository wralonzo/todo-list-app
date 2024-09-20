import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:todo_list_app/ViewModel/task/task_view_model.dart';
import 'package:todo_list_app/model/task/add_task_model.dart';
import 'package:todo_list_app/view/auth/login_page.dart';

class TaskManagementPage extends StatefulWidget {
  const TaskManagementPage({super.key});

  @override
  State<TaskManagementPage> createState() => _TaskManagementPageState();
}

class _TaskManagementPageState extends State<TaskManagementPage> {
  @override
  void initState() {
    super.initState();
    // Obtener tareas al iniciar la página
    Provider.of<TaskViewModel>(context, listen: false).fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Task Management'),
        actions: [
          // Filtros en el AppBar
          PopupMenuButton<String>(
            onSelected: (filter) {
              context.read<TaskViewModel>().filter = filter;
              // ignore: invalid_use_of_protected_member
              context.read<TaskViewModel>().notifyListeners();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "all",
                child: Text("All Tasks"),
              ),
              const PopupMenuItem(
                value: "completed",
                child: Text("Completed"),
              ),
              const PopupMenuItem(
                value: "progress",
                child: Text("Progress"),
              ),
              const PopupMenuItem(
                value: "pending",
                child: Text("Pending"),
              ),
            ],
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Consumer<TaskViewModel>(
        builder: (context, taskViewModel, child) {
          if (taskViewModel.isLoading && taskViewModel.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !taskViewModel.isLoading) {
                  taskViewModel.fetchTasks();
                }
                return true;
              },
              child: DragAndDropLists(
                itemDecorationWhileDragging: BoxDecoration(
                  color: Colors.grey[300],
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                children: [
                  DragAndDropList(
                    header: const Text("Tareas"),
                    children: taskViewModel.filteredTasks.map((task) {
                      return DragAndDropItem(
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.description),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                onItemReorder:
                    (oldIndex, oldListIndex, newItemIndex, newListIndex) {
                  taskViewModel.reorderTasks(oldIndex, newItemIndex);
                },
                onListReorder: (oldListIndex, newListIndex) {
                  // Maneja la reordenación de listas si es necesario
                },
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nueva Tarea',
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newTask = TaskInsert(
                    title: titleController.text,
                    description: descriptionController.text,
                    userId: 1,
                    dueDate: DateTime.now(),
                    status: 'pending');
                Provider.of<TaskViewModel>(context, listen: false)
                    .addTask(newTask);
                Navigator.of(ctx).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

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
        title: const Text('ToDo List'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (filter) {
              context.read<TaskViewModel>().filter = filter;
              context.read<TaskViewModel>().notifyListeners();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "all", child: Text("Todas")),
              const PopupMenuItem(
                  value: "completed", child: Text("Completadas")),
              const PopupMenuItem(
                  value: "progress", child: Text("En progreso")),
              const PopupMenuItem(value: "pending", child: Text("Pendientes")),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ));
            },
            icon: const Icon(Icons.logout),
          )
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
              listPadding: const EdgeInsets.all(10),
              itemDecorationWhileDragging: BoxDecoration(
                color: Colors.grey[300],
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 4, spreadRadius: 2),
                ],
              ),
              children: [
                DragAndDropList(
                  canDrag: true,
                  children: taskViewModel.filteredTasks.map((task) {
                    return DragAndDropItem(
                      child: Dismissible(
                        key: Key(task.id.toString()),
                        background: Container(color: Colors.red),
                        onDismissed: (direction) {
                          // Obtener el índice de la tarea que se está eliminando
                          final removedTask = task;
                          // Eliminar tarea de la lista
                          taskViewModel.tasks.remove(task);
                          // Mostrar SnackBar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Center(
                                    child: Text(
                                        "${removedTask.title} eliminado"))),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(task.id.toString()),
                          ),
                          title: Text(task.title),
                          subtitle: Text(task.description),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              onItemReorder:
                  (oldIndex, oldListIndex, newItemIndex, newListIndex) {
                taskViewModel.reorderTasks(oldIndex, newItemIndex);
              },
              onListReorder: (oldListIndex, newListIndex) {},
            ),
          );
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
                  status: 'pending',
                );
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

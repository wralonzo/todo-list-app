import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/ViewModel/auth/auth_view_model.dart';
import 'package:todo_list_app/ViewModel/task/task_view_model.dart'; // Asegúrate de que este archivo exista
import 'package:todo_list_app/view/auth/login_page.dart';
import 'package:todo_list_app/view/auth/register_page.dart';
import 'package:todo_list_app/view/task/task_page.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  // Zonas horarias para mandar notificaciones
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(
            create: (context) => TaskViewModel()), // Proveedor para tareas
      ],
      child: MaterialApp(
        title: 'To-Do List App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(), // Página de inicio
        routes: {
          '/register': (context) =>
              RegisterPage(), // Ruta para la página de registro
          '/home': (context) =>
              const TaskManagementPage(), // Ruta para la página de gestión de tareas
        },
      ),
    );
  }
}

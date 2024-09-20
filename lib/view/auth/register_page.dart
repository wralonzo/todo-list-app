import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/ViewModel/auth/auth_view_model.dart';
import 'package:todo_list_app/shared/snackbar.dart';

class RegisterPage extends StatelessWidget {
  final _userController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idDeviceController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _userController,
                decoration: const InputDecoration(labelText: 'Usuario'),
              ),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _surnameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    bool response =
                        await Provider.of<AuthViewModel>(context, listen: false)
                            .register(
                      _userController.text,
                      _firstNameController.text,
                      _surnameController.text,
                      _passwordController.text,
                      'test09090',
                    );
                    if (!response) {
                      showErrorMessage(context, 'Usuario no regisgrado');
                      return;
                    }
                    showErrorMessage(context, 'Usuario regisgrado');
                    Navigator.of(context)
                        .pop(); // Regresar a la pantalla de login
                  } catch (error) {
                    showErrorMessage(context, 'Servicio no disponible');
                  }
                },
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

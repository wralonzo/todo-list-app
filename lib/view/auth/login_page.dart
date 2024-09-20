import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/ViewModel/auth/auth_view_model.dart';
import 'package:todo_list_app/shared/snackbar.dart';
import 'package:todo_list_app/view/auth/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await loginAuth();
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ));
                  },
                  child: const Text('¿No tienes cuenta? Regístrate aquí.'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginAuth() async {
    try {
      dynamic response =
          await Provider.of<AuthViewModel>(context, listen: false)
              .login(_userController.text, _passwordController.text);
      if (!response['success']) {
        showErrorMessage(context, response['message']);
        return;
      }
      Navigator.of(context).pushReplacementNamed('/home');
      return;
    } catch (error) {
      showErrorMessage(
          context, "Inicio de sesión fallido. Verifica tus credenciales.");
    }
  }
}

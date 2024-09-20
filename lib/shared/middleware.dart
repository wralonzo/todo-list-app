import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/ViewModel/auth/auth_view_model.dart';

class AuthMiddleware extends StatelessWidget {
  final Widget child;

  const AuthMiddleware({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Provider.of<AuthViewModel>(context, listen: false).validateToken(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == true) {
          return child;
        }

        return const Scaffold(
          body: Center(
            child: Text('Session expired. Please login again.'),
          ),
        );
      },
    );
  }
}

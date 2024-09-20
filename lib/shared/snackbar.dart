import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String message) {
  final snackBar = SnackBar(content: Center(child: Text(message)));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

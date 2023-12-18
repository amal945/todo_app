import 'package:flutter/material.dart';

void showFailureMessage(BuildContext context, {required String message}) {
  final snackbar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 1),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

  void showSuccessMessage(BuildContext context, {required String message}) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

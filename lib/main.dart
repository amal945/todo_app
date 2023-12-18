import 'package:flutter/material.dart';
import 'package:todo_app_api/screens/todolist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TodoListPage(),
      theme: ThemeData.dark(),
    );
  }
}

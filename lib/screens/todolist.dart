import 'package:flutter/material.dart';
import 'package:todo_app_api/Services/todo_service.dart';
import 'package:todo_app_api/screens/add_page.dart';
import 'package:todo_app_api/utils/snackbar_helper.dart';
import 'package:todo_app_api/widget/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  List items = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("To do app")),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Text("No task added"),
            ),
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  return TodoCard(
                      index: index,
                      item: item,
                      navigateEdit: navigateToEditPage,
                      delteById: deleteById);
                }),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddPage();
        },
        label: const Text("Add Task"),
      ),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => AddTodoPage(todo: item));
    await Navigator.push(context, route);
    fetchTodo();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    await Navigator.push(context, route);
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchToDo();
    if (response != null) {
      setState(() {
        items = response;
      });
      setState(() {
        isLoading = false;
      });
    } else {
      showFailureMessage(context, message: "No data available");
    }
  }

  Future<void> deleteById(String id) async {
    final isSucess = await TodoService.deleteById(id);
    if (isSucess == true) {
      //Remove items from the list
      showSuccessMessage(context, message: "Successfully deleted");
      final filtered = items.where((element) => element["_id"] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showFailureMessage(context, message: "Delete Failed");
    }
  }
}

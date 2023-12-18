// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:todo_app_api/Services/todo_service.dart';
import 'package:todo_app_api/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo["title"];
      final desciption = todo["description"];
      titleController.text = title;
      descriptionController.text = desciption;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Task" : "Add Task"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                isEdit ? updateData() : submitData();
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(isEdit ? "Update" : "Submit"),
              ))
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print("You cant call update method without todo datat");
      return;
    }
    final id = todo["_id"];

    //get the data from the form

    final isResponse = await TodoService.updateToDo(id, body);
    // submit updated data to the server

    if (isResponse) {
      titleController.text = "";
      descriptionController.text = "";

      showSuccessMessage(context, message: "Updation success");
    } else {
      showFailureMessage(context, message: "Updation failed");
    }
  }

  Future<void> submitData() async {
    //get the data from the form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    // submit the data to the server
    final isResponse = await TodoService.addData(body);
    // show the succes or failed message based on the status
    if (isResponse) {
      titleController.text = "";
      descriptionController.text = "";
      print("Creation success");
      showSuccessMessage(context, message: "Creation success");
    } else {
      print("creation failed");
      showFailureMessage(context, message: "creation failed");
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {"title": title, "description": description, "is_completed": false};
  }
}

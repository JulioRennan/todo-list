import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_flutter/model/task_model.dart';
import '../../utils/validators/validate_is_empty.dart';

class CreateTaskBottomSheet extends StatefulWidget {
  const CreateTaskBottomSheet({
    super.key,
    required this.onTaskCreated,
  });
  final Function(TaskModel taskEntity) onTaskCreated;

  @override
  State<CreateTaskBottomSheet> createState() => _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends State<CreateTaskBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final newTask = TaskModel(
    description: "",
    isDone: false,
    shouldEndAt: DateTime.now(),
    isSelected: false,
  );
  final descriptionController = TextEditingController();
  final shouldEndAtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Form(
            key: formKey,
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Descreva sua nova tarefa",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      )
                    ],
                  ),
                  Spacer(),
                  TextFormField(
                    validator: validateRequiredField,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.edit),
                      labelText: "Descrição",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: shouldEndAtController,
                    onChanged: (value) => newTask.description = value,
                    decoration: InputDecoration(
                      labelText: "Data de realização",
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    validator: validateRequiredField,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365 * 10)),
                      );
                      if (date != null) {
                        newTask.shouldEndAt = date;
                        shouldEndAtController.text =
                            DateFormat("dd/MM/yy").format(date);
                      }
                    },
                  ),
                  SizedBox(height: 8),
                  Spacer(),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text(
                        "Salvar tarefa",
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          newTask.description = descriptionController.text;
                          widget.onTaskCreated.call(newTask);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

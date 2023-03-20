import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_flutter/model/task_model.dart';
import '../../utils/validators/validate_is_empty.dart';

class EditTaskBottomSheet extends StatefulWidget {
  const EditTaskBottomSheet({
    super.key,
    required this.onEditComplete,
    required this.taskToEdit,
  });

  final Function(TaskModel taskEntity) onEditComplete;
  final TaskModel taskToEdit;

  @override
  State<EditTaskBottomSheet> createState() => _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends State<EditTaskBottomSheet> {
  final formKey = GlobalKey<FormState>();

  final descriptionController = TextEditingController();
  final shouldEndAtController = TextEditingController();
  final completedAtController = TextEditingController();
  DateTime? shouldEndAt;
  DateTime? completedAt;
  late bool isDone;

  @override
  void initState() {
    super.initState();
    shouldEndAtController.text = widget.taskToEdit.shouldEndAt.format;
    descriptionController.text = widget.taskToEdit.description;
    completedAtController.text = widget.taskToEdit.completedAt?.format ?? "";
    isDone = widget.taskToEdit.isDone;
  }

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
              height: 450,
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
                  Divider(),
                  Spacer(),
                  SizedBox(height: 8),
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
                    onChanged: (value) => widget.taskToEdit.description = value,
                    decoration: InputDecoration(
                      labelText: "Data de realização",
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    validator: validateRequiredField,
                    onTap: () async {
                      shouldEndAt = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365 * 10)),
                      );
                      if (shouldEndAt != null) {
                        widget.taskToEdit.shouldEndAt = shouldEndAt!;
                        shouldEndAtController.text =
                            DateFormat("dd/MM/yy").format(shouldEndAt!);
                      }
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: completedAtController,
                    onChanged: (value) => widget.taskToEdit.description = value,
                    decoration: InputDecoration(
                      labelText: "Data de realização",
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    validator: validateRequiredField,
                    onTap: () async {
                      completedAt = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365 * 10)),
                      );
                      if (completedAt != null) {
                        widget.taskToEdit.completedAt = completedAt!;
                        shouldEndAtController.text =
                            DateFormat("dd/MM/yy").format(completedAt!);
                      }
                    },
                  ),
                  SizedBox(height: 8),
                  CheckboxListTile(
                    value: isDone,
                    activeColor: Colors.greenAccent,
                    title: Text(
                      "Tarefa completada",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isDone = value ?? false;
                      });
                    },
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text(
                        "Salvar edição",
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          widget.taskToEdit.description =
                              descriptionController.text;
                          widget.onEditComplete.call(widget.taskToEdit);
                          widget.taskToEdit.completedAt =
                              completedAt ?? widget.taskToEdit.completedAt;
                          widget.taskToEdit.shouldEndAt =
                              shouldEndAt ?? widget.taskToEdit.shouldEndAt;
                          widget.taskToEdit.isDone = isDone;
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

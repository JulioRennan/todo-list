import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_flutter/model/task_model.dart';

class CardTask extends StatefulWidget {
  const CardTask({
    super.key,
    required this.task,
    required this.onRemoveTaped,
    required this.onToogleTaped,
  });
  final TaskModel task;
  final Function() onRemoveTaped;
  final Function() onToogleTaped;

  @override
  State<CardTask> createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
  final dateformat = DateFormat('dd/MM/yyyy');
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            color: colorCard,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.task.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: widget.onRemoveTaped,
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Foi completada",
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 10,
                      width: 16,
                      child: Checkbox(
                        value: widget.task.isDone,
                        activeColor: Colors.greenAccent,
                        onChanged: (_) {
                          setState(() {
                            widget.task.isDone = !widget.task.isDone;
                            widget.onToogleTaped.call();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "inicio ${dateformat.format(widget.task.shouldEndAt)}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "finalizado ${dateformat.format(widget.task.shouldEndAt)}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Color get colorCard {
    switch (widget.task.taskStatus) {
      case TaskStatus.completed:
        return Colors.greenAccent;
      case TaskStatus.delayed:
        return Colors.redAccent;
      case TaskStatus.inDay:
        return Colors.orangeAccent;
      case TaskStatus.pending:
        return Colors.blueAccent;
    }
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_flutter/model/task_model.dart';
import 'package:todo_list_flutter/view/components/card_task.dart';

import '../components/create_task_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final listKeyAll = GlobalKey<AnimatedListState>();
  final listKeyCompleted = GlobalKey<AnimatedListState>();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (timer) async {
        prefs = await SharedPreferences.getInstance();
        setState(() {
          isLoading = false;
        });
        final list = prefs.getStringList("todo-list");
        if (list == null) return;
        todoList.addAll(list.map((e) => TaskModel.fromJson(e)));
      },
    );
  }

  final todoList = <TaskModel>[];
  final _offset = Tween(
    begin: const Offset(1, 0),
    end: const Offset(0, 0),
  );
  final _duration = const Duration(milliseconds: 500);
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final listController = ScrollController();

  late SharedPreferences prefs;
  int currentOption = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        elevation: 0,
        title: Text("Tarefas do dia a dia"),
        actions: [
          IconButton(
            onPressed: () => _removeItem(0),
            icon: Icon(Icons.delete),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.black54,
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) => CreateTaskBottomSheet(
              onTaskCreated: (task) async {
                await _addItem(task);
                Navigator.pop(context);
                setState(() {
                  currentOption = 0;
                });
              },
            ),
          );
        },
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            SizedBox(height: 10),
            ToggleButtons(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.grey[700],
              selectedColor: Colors.white,
              fillColor: Colors.black54,
              color: Colors.black54,
              constraints: BoxConstraints(
                minHeight: 40.0,
                minWidth: MediaQuery.of(context).size.width / 2 - 8,
              ),
              children: [
                Text("Todas"),
                Text("Completadas"),
              ],
              isSelected: currentOptions,
              onPressed: (index) {
                setState(() {
                  currentOption = index;
                  listKey.currentState?.build(context);
                });
              },
            ),
            if (todoListFiltered.isNotEmpty)
              Expanded(
                child: AnimatedList(
                  key: listKey,
                  controller: listController,
                  initialItemCount: todoListFiltered.length + 1,
                  itemBuilder: (context, index, animation) {
                    if (todoListFiltered.length == index) {
                      return const SizedBox(height: 80);
                    }
                    final task = todoListFiltered[index];
                    return SlideTransition(
                      position: animation.drive(_offset),
                      child: CardTask(
                        task: task,
                        onToogleTaped: () => _saveItens(),
                        onRemoveTaped: () => _removeItem(index),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      }),
    );
  }

  GlobalKey<AnimatedListState> get listKey {
    return currentOption == 0 ? listKeyAll : listKeyCompleted;
  }

  Color get randomColor =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1);

  Future<void> _saveItens() async {
    await prefs.setStringList(
      "todo-list",
      todoList.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> _addItem(TaskModel task) async {
    await _saveItens();
    await listController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    todoList.insert(0, task);
    listKey.currentState!.insertItem(0, duration: _duration);
  }

  List<bool> get currentOptions {
    final options = [false, false];
    options[currentOption] = true;
    return options;
  }

  List<TaskModel> get todoListFiltered {
    if (currentOption == 0) return todoList;
    return todoList.where((element) => element.isDone).toList();
  }

  _removeItem(int index) {
    final task = todoListFiltered[index];

    listKey.currentState!.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: SlideTransition(
          position: animation.drive(_offset),
          child: CardTask(
            task: task,
            onToogleTaped: () {},
            onRemoveTaped: () {},
          ),
        ),
      ),
      duration: _duration,
    );
    todoListFiltered.removeAt(index);
  }
}

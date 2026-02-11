import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/util/dialog_box.dart';
import 'package:todo_app/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  // ignore: use_super_parameters
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //reference the hive box
  final _myBox = Hive.box('myBox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is the first time ever opening the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
    } else {
      // there already exists data, so load it
      db.loadData();
    }
    super.initState();
  }

  //text controller
  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      if (_controller.text.trim().isNotEmpty) {
        // store trimmed task text, completion state, and creation timestamp
        db.toDoList.add([
          _controller.text.trim(),
          false,
          DateTime.now().toString(),
        ]);
        _controller.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Task name cannot be empty!"),
            backgroundColor: AppColors.darkRed,
          ),
        );
      }
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
    db.updateDataBase();
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  void editTask(int index) {
    _controller.text = db.toDoList[index][0];
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: () => saveEditedTask(index),
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void saveEditedTask(int index) {
    setState(() {
      if (_controller.text.trim().isNotEmpty) {
        db.toDoList[index][0] = _controller.text.trim();
        _controller.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Task name cannot be empty!"),
            backgroundColor: AppColors.darkRed,
          ),
        );
      }
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6EFE6),
      appBar: AppBar(
        backgroundColor: AppColors.blurple,
        title: Center(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: AppColors.blurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text('About', style: TextStyle(color: Colors.white)),
                    content: Text(
                      'Made by 5trawb3rry (github/discord) + Youtube tutorials and special thanks to CoPilot for UI design help',
                      style: TextStyle(
                        color: AppColors.lightBeige,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'OK',
                          style: TextStyle(color: AppColors.lightBeige),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.task_alt, color: AppColors.lightBeige, size: 28),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: AppColors.blurple,
        child: const Icon(Icons.add, color: AppColors.lightBeige),
      ),
      body: db.toDoList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No tasks yet!",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Press the add button to add a new task.\n Slide left on the task to delete it.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 20, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tasks to be completed',
                      style: TextStyle(
                        color: AppColors.blurple,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: db.toDoList.length,
                    itemBuilder: (context, index) {
                      return TodoTile(
                        taskName: db.toDoList[index][0],
                        taskCompleted: db.toDoList[index][1],
                        onChanged: (value) => checkBoxChanged(value!, index),
                        deleteFunction: (context) => deleteTask(index),
                        onEdit: (context) => editTask(index),
                        createdAt:
                            DateTime.tryParse(
                              db.toDoList[index].length > 2
                                  ? db.toDoList[index][2]
                                  : '',
                            ) ??
                            DateTime.now(),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

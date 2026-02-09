import 'package:hive/hive.dart';

class ToDoDataBase {
  List toDoList = [];
  // reference our box
  final _myBox = Hive.box('myBox');

  void loadData() {
    toDoList = _myBox.get("TODOLIST", defaultValue: []);
  }

  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}

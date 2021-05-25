import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String>? taskList = ["naren"];
List<String>? boxValue = ["false"];
void getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  taskList = prefs.getStringList("task");
  boxValue = prefs.getStringList("check");
  if (taskList == null) {
    taskList = ["Naren", "Abhishek"];
    boxValue = ["false", "false"];
  }
}

void setData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("task", taskList!);
  prefs.setStringList("check", boxValue!);
}

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: taskList!.length,
      itemBuilder: (context, index) {
        return TaskTile(
          taskTitle: taskList![index],
          isChecked: boxValue![index] == 'true',
          longPressCallback: () {
            setState(() {
              taskList!.removeAt(index);
              boxValue!.removeAt(index);
              print(taskList);
              setData();
            });
          },
        );
      },
    );
  }
}

class TaskTile extends StatefulWidget {
  bool? isChecked;
  final String? taskTitle;
  //final Function? checkboxCallback;
  final Function longPressCallback;

  TaskTile(
      {this.isChecked = false,
      this.taskTitle,
      required this.longPressCallback});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        setState(() {
          widget.longPressCallback();
        });
      },
      title: Text(
        widget.taskTitle!,
        style: TextStyle(
          decoration: widget.isChecked! ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
          activeColor: Colors.lightBlueAccent,
          value: widget.isChecked!,
          onChanged: (value) {
            setState(() {
              widget.isChecked = value!;
            });
          }),
    );
  }
}

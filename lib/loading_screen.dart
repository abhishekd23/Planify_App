import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_new/task_screen.dart';

int uid = 0;

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<String>? Tasks = [];
  List<String>? checkbox = [];
  List<String>? date = [];
  List<String>? id = [];
  int? num;

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    Tasks = prefs.getStringList('Tasks');
    checkbox = prefs.getStringList('Check');
    num = prefs.getInt('Task Number');
    date = prefs.getStringList('Date');
    id = prefs.getStringList('Id');
    if (Tasks == null || checkbox == null || num == 0) {
      Tasks = ["Hey! Add a task"];
      checkbox = ["false"];
      date = ["1969-07-20 20:18:04Z"];
      id = ['${uid.toString()}'];
    }
    num = Tasks!.length;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return TaskScreen(
          tasks: Tasks,
          checkBox: checkbox,
          num: num,
          dates: date,
          id: id,
        );
      }),
    );
    uid = int.parse(id!.last);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal,
        body: SpinKitCircle(
          color: Colors.white,
        ));
  }
}

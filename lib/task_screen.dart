import 'dart:core';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_new/change.dart';
import 'package:todo_app_new/loading_screen.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({this.tasks, this.checkBox, this.num, this.dates, this.id});
  final List<String>? tasks;
  final List<String>? checkBox;
  final List<String>? dates;
  final List<String>? id;
  int? num;

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? newTask;
  String? val;
  bool? isChecked = false;
  DateTime? date;

  void setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    prefs.setStringList('Tasks', widget.tasks!);
    prefs.setStringList('Check', widget.checkBox!);
    prefs.setInt('Task Number', widget.num!);
    prefs.setStringList('Date', widget.dates!);
    prefs.setStringList('Id', widget.id!);
  }

  Future<void> _cancelNotificationWithTag(String t) async {
    await flutterLocalNotificationsPlugin.cancel(0, tag: t);
  }

  Future<void> callNotifs() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(initSetttings);
    for (int i = 0; i < widget.tasks!.length; i++) {
      await flutterLocalNotificationsPlugin.schedule(
        uid++,
        'Planify',
        '${(DateTime.parse(widget.dates![i]).difference(DateTime.now()).inMinutes) / 2} minutes Left',
        date!.subtract(
          Duration(
            minutes: (DateTime.parse(widget.dates![i])
                    .difference(DateTime.now())
                    .inMinutes ~/
                2),
          ),
        ),
        const NotificationDetails(
            android:
                AndroidNotificationDetails('Abhishek', 'Abhishek', 'Abhishek')),
        androidAllowWhileIdle: true,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(initSetttings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.cyanAccent,
      floatingActionButton: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.teal,
          child: Icon(
            Icons.add,
            color: Provider.of<ThemeModel>(context).currentTheme ==
                    ThemeData.dark()
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) => Container(
                height: MediaQuery.of(context).viewInsets.bottom + 270.0,
                color: Provider.of<ThemeModel>(context).currentTheme ==
                        ThemeData.dark()
                    ? Colors.black26.withOpacity(0.0)
                    : Colors.white.withOpacity(0.0),
                child: Container(
                  height: MediaQuery.of(context).viewInsets.bottom + 270.0,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Provider.of<ThemeModel>(context).currentTheme ==
                            ThemeData.dark()
                        ? Colors.black26
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Add Task',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                          color:
                              Provider.of<ThemeModel>(context).currentTheme ==
                                      ThemeData.dark()
                                  ? Colors.white
                                  : Colors.teal,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextField(
                        autofocus: true,
                        textAlign: TextAlign.center,
                        cursorColor:
                            Provider.of<ThemeModel>(context).currentTheme ==
                                    ThemeData.dark()
                                ? Colors.white
                                : Colors.teal,
                        onChanged: (newText) {
                          newTask = newText;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "Add DEADLINE",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Provider.of<ThemeModel>(context)
                                          .currentTheme ==
                                      ThemeData.dark()
                                  ? Colors.white
                                  : Colors.teal,
                            ),
                          ),
                        ),
                      ),
                      DateTimeFormField(
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.black45),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.event_note),
                        ),
                        firstDate: DateTime.now(),
                        mode: DateTimeFieldPickerMode.dateAndTime,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (e) => (e?.day ?? 0) == 1
                            ? 'Please not the first day'
                            : null,
                        onDateSelected: (DateTime value) async {
                          this.setState(() {
                            date = value;
                          });
                          await flutterLocalNotificationsPlugin.schedule(
                            uid++,
                            'Planify',
                            '${(date!.difference(DateTime.now()).inMinutes) / 2} minutes Left',
                            date!.subtract(
                              Duration(
                                minutes: (date!
                                        .difference(DateTime.now())
                                        .inMinutes ~/
                                    2),
                              ),
                            ),
                            const NotificationDetails(
                                android: AndroidNotificationDetails(
                                    'Abhishek', 'TimeLeft', 'TaskReminder')),
                            androidAllowWhileIdle: true,
                          );
                          await flutterLocalNotificationsPlugin.schedule(
                            uid++,
                            'Planify',
                            'Time Expired',
                            date!,
                            const NotificationDetails(
                                android: AndroidNotificationDetails(
                                    'Abhishek', 'Abhishek', 'Abhishek')),
                            androidAllowWhileIdle: true,
                          );
                        },
                      ),
                      TextButton(
                        onPressed: () async {
                          this.setState(() {
                            if (newTask!.isNotEmpty && date != null) {
                              widget.tasks!.add(newTask!);
                              widget.checkBox!.add("false");
                              widget.num = widget.num! + 1;
                              widget.dates!.add(date!.toString());
                              widget.id!.add(uid.toString());
                              setData();
                              //newTask = null;
                              //date = null;
                              Navigator.pop(context);
                            }
                          });
                          await flutterLocalNotificationsPlugin.show(
                              0,
                              'Planify',
                              'New Task Added!',
                              NotificationDetails(
                                  android: AndroidNotificationDetails(
                                      "${newTask!}", "hi ", "hi ")));
                        },
                        child: Text(
                          "ADD",
                          style: TextStyle(
                            color: Colors.white,
                            //backgroundColor: Colors.cyanAccent,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.teal),
                          //minimumSize: MaterialStateProperty.all<Size>(20.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              //color: Colors.white,
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            padding: EdgeInsets.only(
                left: 30.0, top: 60.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) => FloatingActionButton(
                    heroTag: null,
                    backgroundColor: Colors.teal,
                    onPressed: () {
                      setState(() {
                        Provider.of<ThemeModel>(context, listen: false)
                            .toggleTheme();
                      });
                    },
                    child: Icon(
                      Icons.brightness_6_outlined,
                      color: Provider.of<ThemeModel>(context).currentTheme ==
                              ThemeData.dark()
                          ? Colors.white
                          : Colors.black,
                      size: 30.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Planify',
                  style: TextStyle(
                    fontSize: 50.0,
                    color: Provider.of<ThemeModel>(context).currentTheme ==
                            ThemeData.dark()
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '*LongPress to delete your task!',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Provider.of<ThemeModel>(context).currentTheme ==
                            ThemeData.dark()
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: ListView.builder(
                itemCount: widget.tasks?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "${widget.tasks![index]}",
                      style: widget.checkBox![index] == 'true'
                          ? TextStyle(color: Colors.green, fontSize: 25.0)
                          : TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: DateTime.parse(widget.dates![index])
                                .difference(DateTime.now())
                                .inMinutes >=
                            0
                        ? (widget.checkBox![index] == 'true'
                            ? Text(
                                "Task Completed",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13.0,
                                ),
                              )
                            : Text(
                                "${DateTime.parse(widget.dates![index]).difference(DateTime.now()).inHours.toString()} hours left",
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ))
                        : Text(
                            "Time Expired",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 13.0,
                            ),
                          ),
                    onLongPress: () async {
                      setState(() {
                        flutterLocalNotificationsPlugin
                            .cancel(int.parse(widget.id![index]) + 1);
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            backgroundColor:
                                Provider.of<ThemeModel>(context).currentTheme ==
                                        ThemeData.light()
                                    ? Colors.white
                                    : Colors.teal,
                            title: Text(
                              'Are you sure you want to END this task?',
                              textAlign: TextAlign.center,
                            ),
                            content: Text(
                              "${widget.tasks![index]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                  setState(() {
                                    widget.num = widget.num!;
                                  });
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    widget.num = widget.num! - 1;
                                    widget.tasks!.removeAt(index);
                                    widget.checkBox!.removeAt(index);
                                    widget.dates!.removeAt(index);
                                    widget.id!.removeAt(index);
                                    setData();
                                  });
                                  Navigator.pop(context, 'OK');
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        // getData();
                      });
                    },
                    trailing: Checkbox(
                      activeColor: Colors.cyanAccent,
                      value: widget.checkBox![index] == 'false' ? false : true,
                      onChanged: (value) async {
                        this.setState(
                          () {
                            widget.checkBox![index] = value!.toString();
                            if (widget.checkBox![index] == 'true') {
                              flutterLocalNotificationsPlugin
                                  .cancel(int.parse(widget.id![index]));

                              flutterLocalNotificationsPlugin
                                  .cancel(int.parse(widget.id![index]) + 1);
                            }
                            setData();
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

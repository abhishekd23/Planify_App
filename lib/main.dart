import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_new/change.dart';
import 'package:todo_app_new/loading_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeModel>(
      create: (context) => ThemeModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeModel>(context).currentTheme,
      home: LoadingScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:todo_diary/services/DatabaseService.dart';
import 'package:todo_diary/viewmodels/TodoListModel.dart';
import 'package:todo_diary/views/HomeView.dart';

void main() {
  runApp(MyApp());
  // DatabaseService().deleteAll();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color(0xff242542),
          accentColor: Colors.amber,
          primarySwatch: Colors.amber,
          buttonColor: Colors.amber,
        ),
        home: ChangeNotifierProvider<TodoListModel>(
          create: (context) => TodoListModel(),
          child: HomeView(),
        ));
  }
}

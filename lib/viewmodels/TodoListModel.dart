import 'package:flutter/material.dart';
import 'package:todo_diary/helpers/date.dart';
import 'package:todo_diary/models/Todo.dart';
import 'package:todo_diary/services/DatabaseService.dart';

class TodoListModel extends ChangeNotifier {
  List<Todo> _todoList = List<Todo>();
  String _date;
  List<Todo> get todoList => _todoList;
  String get curDate => _date;
  String get dateText =>
      isItToday(_date) ? 'today' : getDateFormat(DateTime.parse(_date));

  void setDate(String date) {
    _date = date;
    getTodos();
  }

  DatabaseService dbService = new DatabaseService();
  void addTodo({String todoText}) async {
    Todo newTodo = new Todo(
      todoText: todoText,
      addDate: getTodaysDate().toIso8601String(),
      finDate: getTodaysDate().toIso8601String(),
      completed: false,
    );
    await dbService.save(newTodo).then((value) {
      getTodos();
    });
  }

  void getTodos() async {
    await DatabaseService().getTodosByDate(_date).then((value) {
      _todoList = value;
      notifyListeners();
    });
  }

  void checkTodo(Todo todo) async {
    todo.completed = !todo.completed;
    await DatabaseService().update(todo).then((result) {
      getTodos();
    });
  }

  void deleteTodo(int id) async {
    await DatabaseService().delete(id).then((value) => getTodos());
  }

  void updateYesterdays() async {
    await DatabaseService()
        .getIncompleteTodos(getPrevDate(1).toIso8601String())
        .then(
          (value) => value.forEach(
            (todo) async {
              todo.finDate = getTodaysDate().toIso8601String();
              await DatabaseService().update(todo);
            },
          ),
        );
  }
}

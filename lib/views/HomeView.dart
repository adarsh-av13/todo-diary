import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_diary/helpers/date.dart';
import 'package:todo_diary/viewmodels/TodoListModel.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String date = getTodaysDate().toIso8601String();
    Provider.of<TodoListModel>(context, listen: false).setDate(date);
    Provider.of<TodoListModel>(context, listen: false).updateYesterdays();
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [theme.primaryColor, Color(0xff32344d)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                width: 2.0,
                color: Colors.amber,
              ),
            )),
            padding: const EdgeInsets.all(8.0),
            child: Consumer<TodoListModel>(
              builder: (context, todoListModel, child) {
                return AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    todoListModel.dateText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: theme.accentColor,
                      ),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        ).then(
                          (date) {
                            if (date != null) {
                              Provider.of<TodoListModel>(context, listen: false)
                                  .setDate(date.toIso8601String());
                            }
                          },
                        );
                      },
                    )
                  ],
                );
              },
            ),
          ),
        ),
        body: Consumer<TodoListModel>(
          builder: (context, todoListModel, child) {
            return ListView.builder(
              itemCount: todoListModel.todoList.length,
              itemBuilder: (context, index) {
                return todoItem(todoListModel, index);
              },
            );
          },
        ),
        floatingActionButton: Consumer<TodoListModel>(
          builder: (context, todoListModel, child) {
            return FloatingActionButton(
              onPressed: isItToday(todoListModel.curDate)
                  ? () {
                      _showAddDialog(context);
                    }
                  : null,
              child: Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }

  Widget todoItem(TodoListModel todoListModel, int index) {
    final todo = todoListModel.todoList[index];
    return Dismissible(
      key: Key(todo.id.toString()),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.amber),
          ),
        ),
        child: ListTile(
          dense: false,
          title: AnimatedDefaultTextStyle(
            style: todo.completed
                ? TextStyle(
                    fontSize: 18.0,
                    letterSpacing: 1.5,
                    height: 1.8,
                    color: Colors.white70,
                    decoration: TextDecoration.lineThrough,
                    decorationThickness: 3.0,
                  )
                : TextStyle(
                    fontSize: 18.0,
                    letterSpacing: 1.5,
                    height: 1.8,
                    color: Colors.white,
                  ),
            duration: const Duration(milliseconds: 200),
            child: Text(
              todo.todoText,
            ),
          ),
          trailing: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[900],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              color: todo.completed ? Colors.amber : Colors.grey,
              icon: Icon(Icons.check),
              onPressed: isItToday(todoListModel.curDate)
                  ? () {
                      todoListModel.checkTodo(todo);
                    }
                  : null,
              disabledColor: Colors.amber,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        todoListModel.deleteTodo(todo.id);
      },
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
        child: ListTile(
          title: Text(
            todo.todoText,
            style: TextStyle(color: Colors.grey[100], fontSize: 18.0),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              size: 30.0,
            ),
            onPressed: null,
            disabledColor: Colors.red,
          ),
        ),
        color: Colors.grey[100],
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: _confirmDelete,
    );
  }

  Future<bool> _confirmDelete(DismissDirection direction) async {
    return await showDialog(
          context: (context),
          builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).primaryColor,
              content: Text(
                'Confirm delete?',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ]),
        ) ??
        false;
  }

  _showAddDialog(BuildContext context) {
    TextEditingController _todoTextController = TextEditingController();
    final todoListModel = Provider.of<TodoListModel>(context, listen: false);
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Theme.of(context).primaryColor,
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        controller: _todoTextController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey,
                          // labelText: "todo",
                          hintText: "Enter todo",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text('Save'),
                          textColor: Colors.amber,
                          onPressed: () {
                            todoListModel.addTodo(
                                todoText: _todoTextController.text);
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text('Cancel'),
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }
}

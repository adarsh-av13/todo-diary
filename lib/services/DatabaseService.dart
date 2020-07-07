import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:todo_diary/models/Todo.dart';

class DatabaseService {
  static Database _db;
  static const String DB_NAME = 'todos.db';
  static const String TABLE = 'todos';
  static const String ID = 'id';
  static const String TODOTEXT = 'todoText';
  static const String COMPLETED = 'completed';
  static const String ADDDATE = 'addDate';
  static const String FINDATE = 'finDate';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDb();
    return _db;
  }

  _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $TODOTEXT TEXT NOT NULL, $COMPLETED INTEGER NOT NULL, $ADDDATE TEXT NOT NULL, $FINDATE TEXT NOT NULL)");
  }

  Future<Todo> save(Todo todo) async {
    var dbClient = await db;
    todo.id = await dbClient.insert(TABLE, todo.toMap());
    print(todo.todoText);
    return todo;
  }

  Future<List<Todo>> getTodos() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE);
    List<Todo> todos = [];
    if (maps.length > 0) {
      maps.forEach((element) {
        todos.add(Todo.fromMap(element));
      });
    }
    return todos;
  }

  Future<List<Todo>> getTodosByDate(String date) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, where: "$FINDATE = ?", whereArgs: [date]);
    List<Todo> todos = [];
    if (maps.length > 0) {
      maps.forEach((element) {
        todos.add(Todo.fromMap(element));
      });
    }
    return todos;
  }

  Future<List<Todo>> getIncompleteTodos(String date) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, where: "$FINDATE = ? AND $COMPLETED = 0", whereArgs: [date]);
    List<Todo> todos = [];
    if (maps.length > 0) {
      maps.forEach((element) {
        todos.add(Todo.fromMap(element));
      });
    }
    return todos;
  }

  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }
  Future deleteAll() async{
    var dbClient = await db;
    await dbClient.rawDelete("DELETE FROM $TABLE");
  }

  Future<int> update(Todo todo) async{
    var dbClient = await db;
    return await dbClient.update(TABLE,todo.toMap(),where: '$ID = ?', whereArgs: [todo.id]);
  }
  Future close() async{
    var dbClient = await db;
    dbClient.close();
  }
}

class Todo {
  int id;
  String todoText;
  bool completed;
  String addDate;
  String finDate;

  Todo({this.id,this.todoText,this.completed,this.addDate,this.finDate});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'todoText': todoText,
      'completed': completed ? 1 : 0,
      'addDate': addDate,
      'finDate': finDate
    };
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    todoText = map['todoText'];
    completed = map['completed'] == 1;
    addDate = map['addDate'];
    finDate = map['finDate'];
  }
}
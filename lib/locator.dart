import 'package:get_it/get_it.dart';
import 'package:todo_diary/viewmodels/TodoListModel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => TodoListModel());
}
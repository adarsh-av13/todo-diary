import 'package:intl/intl.dart';

String getDateFormat(DateTime date) {
  return DateFormat("MMMM dd").format(date).toString();
}

DateTime getTodaysDate() {
  DateTime now = DateTime.now();
  DateTime today = new DateTime(now.year, now.month, now.day);
  return today;
}

DateTime getPrevDate(int days) {
  return getTodaysDate().subtract(Duration(days: days));
}

bool isItToday(String date) {
  return date == getTodaysDate().toIso8601String();
}

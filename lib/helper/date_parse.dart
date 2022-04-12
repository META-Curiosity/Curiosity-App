import 'package:intl/intl.dart';

String dateParse(String date) {
  return date.substring(0, 6) + date.substring(8, 10);
}

//Converts Date time to the form MM-DD-YY
String datetimeToString(DateTime date) {
  DateFormat formatter = DateFormat('MM-dd-y');
  String formattedDate = formatter.format(date);
  print("CHUNK: " +
      formattedDate.substring(0, 6) +
      formattedDate.substring(8, 10));
  return dateParse(formattedDate);
}

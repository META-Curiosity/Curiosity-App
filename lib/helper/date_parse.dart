import 'package:intl/intl.dart';

String dateParse(String date) {
  //MM-dd-yyyy to MM-dd-yy
  String res;
  for (int i = 0; i < date.length; i++) {
    if (i == 6 && i == 7) continue;
    res += date[i];
  }
  return res;
}

String datetimeToString(DateTime date) {
  DateFormat formatter = DateFormat('MM-dd-y');
  String formattedDate = formatter.format(date);
  return dateParse(formattedDate);
}

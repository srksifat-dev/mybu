import 'package:intl/intl.dart';

class Converter {
  static DateTime int2DateTime(int hour, int minute) {
    return DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,hour,minute);
  }

  static int dateTime2minute(DateTime first, DateTime second) {
    return second.difference(first).inMinutes;
  }
}

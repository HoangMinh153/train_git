import 'package:intl/intl.dart';

class Helper {
  DateTime parseDate(String dateString) {
    DateFormat inputFormat =
        DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US');
    DateTime parsedDate = inputFormat.parseUTC(dateString);
    return parsedDate;
  }
}

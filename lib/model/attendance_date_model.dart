import 'package:intl/intl.dart';

class AttendanceDate {
  int id;
  String classid;
  DateTime date;

  AttendanceDate({
    required this.id,
    required this.classid,
    required this.date,
  });

  factory AttendanceDate.fromJson(List<dynamic> json) {
    DateFormat inputFormat =
        DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US');
    DateTime parsedstartDate = inputFormat.parseUTC(json[2]);
    return AttendanceDate(
      id: json[0],
      classid: json[1],
      date: parsedstartDate,
    );
  }
}

List<AttendanceDate> globalAttendanceDateList = [];

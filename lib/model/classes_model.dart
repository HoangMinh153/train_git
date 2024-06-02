import 'package:intl/intl.dart';

class Classes {
  String classId;
  String name;
  int courseLoad;
  String teacherId;
  DateTime startDate;
  DateTime endDate;
  String location;
  String timetable;
  int numberOfStudents;

  Classes({
    required this.classId,
    required this.name,
    required this.courseLoad,
    required this.teacherId,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.timetable,
    required this.numberOfStudents,
  });

  factory Classes.fromJson(List<dynamic> json) {
    DateFormat inputFormat =
        DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US');
    DateTime parsedstartDate = inputFormat.parseUTC(json[4]);
    DateTime parsedendDate = inputFormat.parseUTC(json[5]);
    return Classes(
      classId: json[0],
      name: json[1],
      courseLoad: json[2],
      teacherId: json[3],
      startDate: parsedstartDate,
      endDate: parsedendDate,
      location: json[6],
      timetable: json[7],
      numberOfStudents: json[8],
    );
  }
}

List<Classes> globalClassesList = [];
Classes? classes;

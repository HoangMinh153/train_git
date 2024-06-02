import 'package:intl/intl.dart';

class Student {
  String studentid;
  String fullname;
  String email;
  String phoneNumber;
  String address;
  DateTime dateOfBirth;
  String gender;

  Student({
    required this.studentid,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,
    required this.gender,
  });

  factory Student.fromJson(List<dynamic> json) {
    DateFormat inputFormat =
        DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US');
    DateTime parsedDate = inputFormat.parseUTC(json[5]);
    return Student(
      studentid: json[0],
      fullname: json[1],
      email: json[2],
      phoneNumber: json[3],
      address: json[4],
      dateOfBirth: parsedDate,
      gender: json[6],
    );
  }
}

List<Student> globalStudentList = [];

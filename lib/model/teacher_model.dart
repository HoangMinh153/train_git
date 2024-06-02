import 'package:intl/intl.dart';

class Teacher {
  String id;
  String username;
  String password;
  String fullname;
  String email;
  String phoneNumber;
  String address;
  DateTime dateOfBirth;
  int gender;

  Teacher({
    required this.id,
    required this.username,
    required this.password,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,
    required this.gender,
  });

  factory Teacher.fromJson(List<dynamic> json) {
    DateFormat inputFormat =
        DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US');
    DateTime parsedDate = inputFormat.parseUTC(json[7]);
    return Teacher(
      id: json[0],
      username: json[1],
      password: json[2],
      fullname: json[3],
      email: json[4],
      phoneNumber: json[5],
      address: json[6],
      dateOfBirth: parsedDate,
      gender: json[8],
    );
  }
}

List<Teacher> globalTeacherList = [];

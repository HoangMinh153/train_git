import 'dart:convert';
import 'dart:io';
import 'package:app/model/attendance_date_model.dart';
import 'package:app/model/class_students_model.dart';
import 'package:app/model/student_model.dart';
import 'package:http/http.dart' as http;
import 'package:app/helper/config.dart' as config;
import 'package:app/model/teacher_model.dart';
import 'package:app/model/classes_model.dart';

import 'package:intl/intl.dart';

class ApiService {
  static Future<List<Teacher>> login(String username, String password) async {
    final url = Uri.http(config.baseUrl, config.getTeacher);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      globalTeacherList = data.map((json) => Teacher.fromJson(json)).toList();

      print('Login successful: $data');
      return globalTeacherList;
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }

  static Future<void> loadClasses(Teacher teacher) async {
    globalClassesList.clear();
    final url = Uri.http(config.baseUrl, config.getClassesByTeacherid);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'teacherid': teacher.id,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      for (var item in data) {
        try {
          globalClassesList.add(Classes.fromJson(item));
        } catch (e) {
          print("Error parsing JSON: $e");
        }
      }
      print('Login successful: $data');
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }

  static Future<void> getStudentByClassId(Classes classes) async {
    globalClassStudentList.clear();
    final url = Uri.http(config.baseUrl, config.getStudentByClassid);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'classid': classes.classId,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      for (var item in data) {
        try {
          globalClassStudentList.add(ClassStudent.fromJson(item));
        } catch (e) {
          print("Error parsing JSON: $e");
        }
      }
      print('Login successful: $data');
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }

  static Future<void> getAttendanceDate(String classId) async {
    globalAttendanceDateList.clear();
    final url = Uri.http(config.baseUrl, config.getAttendanceDate);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'classid': classId,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      for (var item in data) {
        try {
          globalAttendanceDateList.add(AttendanceDate.fromJson(item));
        } catch (e) {
          print("Error parsing JSON: $e");
        }
      }
      print('Login successful: $data');
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }

  static Future<Student> getStudentById(String studentid) async {
    final url = Uri.http(config.baseUrl, config.getStudentById);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'studentid': studentid,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      Student selectdStudent = Student.fromJson(data[0]);

      print('Login successful: $data');

      return selectdStudent;
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }

  static Future<Student> getAttendanceByDateAndClassid(
      DateTime date, Classes classes) async {
    final url = Uri.http(config.baseUrl, config.getStudentById);
    String originalString = DateFormat('yyyy-MM-dd').format(date);
    String dateString = originalString.split(" ")[0];
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'date': dateString,
        'classid': classes.classId,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      Student selectdStudent = Student.fromJson(data[0]);

      print('Login successful: $data');

      return selectdStudent;
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }

  static Future<String> uploadImage(File image) async {
    final url = Uri.http(config.baseUrl, config.processImage);
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      return 'Upload successful';
    } else {
      return 'Upload failed';
    }
  }

  static Future<String> updateTeacher(Teacher teacher) async {
    final url = Uri.http(config.baseUrl, config.updateTeacher);
    String originalString =
        DateFormat('yyyy-MM-dd').format(teacher.dateOfBirth);
    String dateString = originalString.split(" ")[0];

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'teacherid': teacher.id,
        'username': teacher.username,
        'password': teacher.password,
        'fullname': teacher.fullname,
        'email': teacher.email,
        'phonenumber': teacher.phoneNumber,
        'address': teacher.address,
        'dateofbirth': dateString,
        'gender': teacher.gender,
      }),
    );

    if (response.statusCode == 200) {
      return 'Teacher updated successfully';
    } else {
      throw Exception('Failed to update teacher');
    }
  }

  static Future<String> updateStudent(Student student) async {
    final url = Uri.http(config.baseUrl, config.updateStudent);
    String originalString =
        DateFormat('yyyy-MM-dd').format(student.dateOfBirth);
    String dateString = originalString.split(" ")[0];

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'studentid': student.studentid,
        'fullname': student.fullname,
        'email': student.email,
        'phonenumber': student.phoneNumber,
        'address': student.address,
        'dateofbirth': dateString,
        'gender': student.gender,
      }),
    );

    if (response.statusCode == 200) {
      return 'Student updated successfully';
    } else {
      throw Exception('Failed');
    }
  }
}

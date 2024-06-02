import 'package:app/attendance.dart';
import 'package:app/helper/api_service.dart';
import 'package:app/model/class_students_model.dart';
import 'package:app/model/student_model.dart';
import 'package:flutter/material.dart';
import 'package:app/model/classes_model.dart';
import 'student_page.dart';

class ClassDetailPage extends StatelessWidget {
  final Classes classes;

  const ClassDetailPage({Key? key, required this.classes}) : super(key: key);

  Future<void> _fetchAttendance(BuildContext context) async {
    try {
      await ApiService.getAttendanceDate(classes.classId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendancePage(classes: classes),
        ),
      );
    } catch (error) {
      // Hiển thị thông báo lỗi nếu có vấn đề xảy ra
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch attendance')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ClassStudent> classStudents = globalClassStudentList;

    return Scaffold(
      appBar: AppBar(
        title: Text(classes.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: classStudents.length,
              itemBuilder: (context, index) {
                final classStudent = classStudents[index];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(classStudent.studentid),
                    onTap: () async {
                      try {
                        Student student = await ApiService.getStudentById(
                            classStudent.studentid);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentPage(student: student),
                          ),
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to load student')),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _fetchAttendance(
                  context), // Gọi hàm _fetchAttendance khi bấm nút
              child: Text('Attendance'),
            ),
          ),
        ],
      ),
    );
  }
}

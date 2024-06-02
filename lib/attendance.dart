import 'package:app/model/attendance_date_model.dart';
import 'package:flutter/material.dart';
import 'package:app/model/classes_model.dart';
import 'package:app/upload_image.dart';
import 'package:intl/intl.dart';

class AttendancePage extends StatelessWidget {
  final Classes classes;

  const AttendancePage({Key? key, required this.classes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<AttendanceDate> attendanceDates = globalAttendanceDateList;

    return Scaffold(
      appBar: AppBar(
        title: Text('Điểm danh cho lớp ${classes.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadImagePage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: attendanceDates.length,
        itemBuilder: (context, index) {
          final date = attendanceDates[index].date;
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(DateFormat('dd/MM/yyyy').format(date)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AttendanceDetailPage(date: date, classes: this.classes),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AttendanceDetailPage extends StatelessWidget {
  final DateTime date;
  final Classes classes;
  const AttendanceDetailPage(
      {Key? key, required this.date, required this.classes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Chi tiết điểm danh ngày ${DateFormat('dd/MM/yyyy').format(date)}'),
      ),
      body: Center(
        child: Text(
            'Chi tiết điểm danh cho ngày ${DateFormat('dd/MM/yyyy').format(date)}'),
      ),
    );
  }
}

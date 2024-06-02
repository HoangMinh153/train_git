import 'package:flutter/material.dart';
import 'login.dart';
import 'upload_image.dart';
import 'data_list.dart';
import 'teacher_list.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/upload': (context) => UploadImagePage(),
        '/data_list': (context) => DataListPage(),
        '/teacher_list': (context) => TeacherListPage(),
      },
    );
  }
}

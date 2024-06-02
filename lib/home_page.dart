import 'package:app/helper/api_service.dart';
import 'package:app/model/student_model.dart';
import 'package:app/model/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/model/classes_model.dart';
import 'class_detail_page.dart';
import 'teacher_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 80),
            child: globalClassesList.isEmpty
                ? Center(child: Text('No classes available'))
                : ListView.builder(
                    itemCount: globalClassesList.length,
                    itemBuilder: (context, index) {
                      final classes = globalClassesList[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(classes.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Start Date: ${DateFormat('dd/MM/yyyy').format(classes.startDate)}'),
                              Text(
                                  'End Date: ${DateFormat('dd/MM/yyyy').format(classes.endDate)}'),
                              Text('Location: ${classes.location}'),
                            ],
                          ),
                          onTap: () {
                            _handleClassTap(context, classes);
                          },
                        ),
                      );
                    },
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherListPage(),
                        ),
                      );
                    },
                    child: Text('Teacher List'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void checkData() {
    if (globalTeacherList.isEmpty) {
      print('globalClassesList is empty');
    }
    if (globalClassesList.isEmpty) {
      print('globalClassesList is empty');
    } else {
      print('globalClassesList has data:');
      for (var classes in globalClassesList) {
        print(
            'Class ID: ${classes.classId}, Name: ${classes.name}, Start Date: ${classes.startDate}, End Date: ${classes.endDate}, Location: ${classes.location}, Timetable: ${classes.timetable}, Number of Students: ${classes.numberOfStudents}');
      }
    }
  }

  void _handleClassTap(BuildContext context, Classes classes) async {
    try {
      await ApiService.getStudentByClassId(classes);
      if (globalStudentList.isEmpty) {}
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClassDetailPage(classes: classes),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }
}

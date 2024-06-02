import 'package:flutter/material.dart';
import 'package:app/model/teacher_model.dart';
import 'package:app/helper/api_service.dart';

class TeacherListPage extends StatefulWidget {
  const TeacherListPage({Key? key}) : super(key: key);

  @override
  _TeacherListPageState createState() => _TeacherListPageState();
}

class _TeacherListPageState extends State<TeacherListPage> {
  List<TextEditingController> _nameControllers = [];
  List<TextEditingController> _emailControllers = [];
  List<TextEditingController> _phoneControllers = [];
  List<TextEditingController> _addressControllers = [];
  List<TextEditingController> _dateOfBirthControllers = [];
  List<TextEditingController> _genderControllers = [];

  @override
  void initState() {
    super.initState();

    for (var teacher in globalTeacherList) {
      _nameControllers.add(TextEditingController(text: teacher.fullname));
      _emailControllers.add(TextEditingController(text: teacher.email));
      _phoneControllers.add(TextEditingController(text: teacher.phoneNumber));
      _addressControllers.add(TextEditingController(text: teacher.address));
      _dateOfBirthControllers.add(TextEditingController(
          text: teacher.dateOfBirth.toLocal().toString().split(' ')[0]));
      _genderControllers
          .add(TextEditingController(text: teacher.gender.toString()));
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var controller in _emailControllers) {
      controller.dispose();
    }
    for (var controller in _phoneControllers) {
      controller.dispose();
    }
    for (var controller in _addressControllers) {
      controller.dispose();
    }
    for (var controller in _dateOfBirthControllers) {
      controller.dispose();
    }
    for (var controller in _genderControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      for (int i = 0; i < globalTeacherList.length; i++) {
        globalTeacherList[i].fullname = _nameControllers[i].text;
        globalTeacherList[i].email = _emailControllers[i].text;
        globalTeacherList[i].phoneNumber = _phoneControllers[i].text;
        globalTeacherList[i].address = _addressControllers[i].text;
        globalTeacherList[i].dateOfBirth =
            DateTime.parse(_dateOfBirthControllers[i].text);
        globalTeacherList[i].gender = int.parse(_genderControllers[i].text);

        await ApiService.updateTeacher(globalTeacherList[i]);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes saved!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher List Page'),
      ),
      body: globalTeacherList.isEmpty
          ? const Center(child: Text('No teachers found.'))
          : ListView.builder(
              itemCount: globalTeacherList.length,
              itemBuilder: (context, index) {
                final teacher = globalTeacherList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _nameControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                            ),
                          ),
                          TextField(
                            controller: _emailControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Email',
                            ),
                          ),
                          TextField(
                            controller: _phoneControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                            ),
                          ),
                          TextField(
                            controller: _addressControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Address',
                            ),
                          ),
                          TextField(
                            controller: _dateOfBirthControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Date of Birth (yyyy-mm-dd)',
                            ),
                          ),
                          TextField(
                            controller: _genderControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Gender (0 for Female, 1 for Male)',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

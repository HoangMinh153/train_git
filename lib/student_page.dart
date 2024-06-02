import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/model/student_model.dart';
import 'package:app/helper/api_service.dart';

class StudentPage extends StatefulWidget {
  final Student student;

  const StudentPage({Key? key, required this.student}) : super(key: key);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late TextEditingController _idController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _genderController;

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.student.studentid);
    _fullNameController = TextEditingController(text: widget.student.fullname);
    _emailController = TextEditingController(text: widget.student.email);
    _phoneNumberController =
        TextEditingController(text: widget.student.phoneNumber);
    _addressController = TextEditingController(text: widget.student.address);
    selectedDate = widget.student.dateOfBirth;
    _dateOfBirthController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(widget.student.dateOfBirth),
    );
    _genderController = TextEditingController(text: widget.student.gender);
  }

  @override
  void dispose() {
    _idController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _updateStudent() async {
    try {
      final updatedStudent = Student(
        studentid: _idController.text,
        fullname: _fullNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneNumberController.text,
        address: _addressController.text,
        dateOfBirth: selectedDate!,
        gender: _genderController.text,
      );

      final response = await ApiService.updateStudent(updatedStudent);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student updated successfully: $response')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update student: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student.fullname),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
              readOnly: true,
            ),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _dateOfBirthController,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateStudent,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:app/helper/api_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  File? _image;

  Future<void> _pickImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      final response = await ApiService.uploadImage(_image!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image Page'),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: _pickImageFromCamera,
              ),
              IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: _pickImageFromGallery,
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null) Image.file(_image!),
            Spacer(),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

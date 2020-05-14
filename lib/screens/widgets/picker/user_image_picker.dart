import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    setState(() {
      _pickedImage = null;
    });

    final pickedImageFile =
        await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _pickImage,
        child: CircleAvatar(
          radius: 48,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
          child: _pickedImage != null ? null : Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}

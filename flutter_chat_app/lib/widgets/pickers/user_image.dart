import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {

  final void Function(File image) sltImage;

  const UserImage(this.sltImage);

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File _pickedImage;

  Future<void> _pickImage() async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.camera,imageQuality: 50,maxWidth: 150);
    if (imageFile == null) return;
    setState(() {
      _pickedImage = File(imageFile.path);
    });
    widget.sltImage(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
          _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
            onPressed: _pickImage,
            textColor: Theme
                .of(context)
                .primaryColor,
            icon: Icon(Icons.image),
            label: Text(
              'Add Image',
            ))
      ],
    );
  }
}

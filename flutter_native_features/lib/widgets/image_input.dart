import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPaths;

class ImageInput extends StatefulWidget {
  Function _saveImage;

  ImageInput(this._saveImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storageFile;

  Future<void> _takePicture() async {
    final imageFile =
        await ImagePicker().getImage(source: ImageSource.camera, maxWidth: 600);
    if (imageFile == null) return;  // if camera open and no click of pic
    setState(() {
      _storageFile = File(imageFile.path);
    });
    final imgFile = File(imageFile.path);
    final appDir = await sysPaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imgFile.path);
    final savedImage = await imgFile.copy('${appDir.path}/$fileName');
    widget._saveImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storageFile != null
              ? Image.file(
                  _storageFile,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            onPressed: () {
              _takePicture();
            },
            icon: Icon(Icons.camera),
            label: const Text('Take Picture'),
            textColor: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }
}

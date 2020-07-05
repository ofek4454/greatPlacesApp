import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;

class ImageInput extends StatefulWidget {
  final Function onImageSelect;

  ImageInput(this.onImageSelect);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _loadedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.getImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Image doesnt taken, Please try again.'),
        ),
      );
      return;
    }
    setState(() {
      _loadedImage = File(pickedImage.path);
    });
    final appDir = await pathProvider.getApplicationDocumentsDirectory();
    final fileName = path.basename(_loadedImage.path);
    final savedImage = await _loadedImage.copy('${appDir.path}/$fileName');
    widget.onImageSelect(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).primaryColor,
            ),
          ),
          alignment: Alignment.center,
          width: min(deviceSize.width, deviceSize.height) * 0.25,
          height: min(deviceSize.width, deviceSize.height) * 0.25,
          child: _loadedImage == null
              ? Text(
                  'No image loaded',
                  textAlign: TextAlign.center,
                )
              : Image.file(
                  _loadedImage,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  height: double.infinity,
                  width: double.infinity,
                ),
        ),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take picture'),
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}

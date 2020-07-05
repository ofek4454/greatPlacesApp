import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/image_input.dart';
import '../providers/places.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;

  void _selsecImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  Future<void> _savePlace() async {
    if (_titleController.text.isEmpty || _pickedImage == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('inValid information'),
          content: Text(
              'please make sure that all filed are compleatlly full and the image is taken'),
        ),
      );
      return;
    }
    Provider.of<Places>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add place')),
      body: LayoutBuilder(
        builder: (ctx, constraints) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          controller: _titleController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.white),
                            labelText: 'Title',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      ImageInput(_selsecImage),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              height: constraints.maxHeight * 0.1,
              child: RaisedButton.icon(
                color: Theme.of(context).accentColor,
                textColor: Theme.of(context).primaryColorDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                icon: Icon(Icons.done),
                label: Text('Add place'),
                onPressed: _savePlace,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

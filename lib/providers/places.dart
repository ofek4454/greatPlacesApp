import 'dart:io';

import 'package:flutter/material.dart';

import '../models/place.dart';

class Places with ChangeNotifier {
  List<Place> _placesList = [];

  List<Place> get placesList {
    return [..._placesList];
  }

  void addPlace(String pickedTitle, File pickedImage) {
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: pickedTitle,
        image: pickedImage,
        location: null);

    _placesList.add(newPlace);
    notifyListeners();
  }
}

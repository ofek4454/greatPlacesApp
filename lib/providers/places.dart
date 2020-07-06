import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class Places with ChangeNotifier {
  List<Place> _placesList = [];

  List<Place> get placesList {
    return [..._placesList];
  }

  Place getPlaceById(String id) {
    return placesList.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
      String pickedTitle, File pickedImage, LatLng pickedLocations) async {
    final address = await LocationHelper.getLocationAddress(
        pickedLocations.latitude, pickedLocations.longitude);
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: pickedTitle,
      image: pickedImage,
      location: PlaceLocation(
        latitude: pickedLocations.latitude,
        longitude: pickedLocations.longitude,
        address: address,
      ),
    );

    _placesList.add(newPlace);
    notifyListeners();
    await DBHelper.insert(
      DBHelper.tableName,
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'loc_lat': newPlace.location.latitude,
        'loc_lng': newPlace.location.longitude,
        'address': newPlace.location.address,
      },
    );
  }

  Future<void> loadPlaces() async {
    final loadedData = await DBHelper.loadData(DBHelper.tableName);
    _placesList = loadedData
        .map((e) => Place(
              id: e['id'],
              title: e['title'],
              image: File(e['image']),
              location: PlaceLocation(
                latitude: e['loc_lat'],
                longitude: e['loc_lng'],
                address: e['address'],
              ),
            ))
        .toList();

    notifyListeners();
  }
}

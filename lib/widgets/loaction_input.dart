import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function _locationChoosen;

  LocationInput(this._locationChoosen);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _locationImageUrl;
  var isLoading = false;

  void _showPreview(double lat, double lng) {
    final url = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);
    setState(() {
      _locationImageUrl = url;
      isLoading = false;
    });
  }

  Future<void> getUserCurrentLocation() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userLocationData = await Location().getLocation();
      widget._locationChoosen(
          userLocationData.latitude, userLocationData.longitude);
      _showPreview(userLocationData.latitude, userLocationData.longitude);
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  Future<void> chooseLocationFromMap() async {
    setState(() {
      isLoading = true;
    });
    final userLocationData = await Location().getLocation();
    final location = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(userLocationData),
        fullscreenDialog: true,
      ),
    );
    _showPreview(location.latitude, location.longitude);
    widget._locationChoosen(location.latitude, location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: deviceSize.width * 0.5,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _locationImageUrl == null
              ? Text(
                  'No location chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _locationImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
        ),
        isLoading
            ? Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 15),
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton.icon(
                    icon: Icon(Icons.location_on),
                    label: Text('use current location'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: getUserCurrentLocation,
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.map),
                    label: Text('choose from map'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: chooseLocationFromMap,
                  ),
                ],
              )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  final LocationData initialLocation;

  MapScreen(this.initialLocation);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedlocation;

  void choseLocation(LatLng position) {
    setState(() {
      _pickedlocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('choose location'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _pickedlocation == null
                ? null
                : () {
                    Navigator.of(context).pop(_pickedlocation);
                  },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.initialLocation.latitude,
                widget.initialLocation.longitude),
            zoom: 16),
        onTap: choseLocation,
        markers: {
          if (_pickedlocation != null)
            Marker(markerId: MarkerId('location'), position: _pickedlocation)
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName = '/place-details';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final placeId = ModalRoute.of(context).settings.arguments as String;
    final place =
        Provider.of<Places>(context, listen: false).getPlaceById(placeId);
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: deviceSize.height * 0.3,
              child: Image.file(
                place.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: Text(
                place.location.address,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: deviceSize.height * 0.2,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    place.location.latitude,
                    place.location.longitude,
                  ),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(placeId),
                    position: LatLng(
                      place.location.latitude,
                      place.location.longitude,
                    ),
                  )
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import './add_place_screen.dart';
import './place_details_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Great places app'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Places>(context, listen: false).loadPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Places>(
                child: Center(
                  child: Text('no places added yet!'),
                ),
                builder: (ctx, places, child) => places.placesList.length <= 0
                    ? child
                    : ListView.builder(
                        itemCount: places.placesList.length,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(places.placesList[i].image),
                          ),
                          title: Text(places.placesList[i].title),
                          subtitle: Text(places.placesList[i].location.address),
                          onTap: () => Navigator.of(context).pushNamed(
                            PlaceDetailsScreen.routeName,
                            arguments: places.placesList[i].id,
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/new_place.dart';
import 'package:favorite_places/provider/place_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/widgets/places_list.dart';

import 'package:favorite_places/screens/place_detail.dart';

// List<Place> placeList = [Place(name: 'name'), Place(name: 'name2')];

class PlacesScreen extends ConsumerStatefulWidget {
  PlacesScreen({
    super.key,
  });

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesScreen();
  }
}
// List<Place>? placeList;

class _PlacesScreen extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  void toScreen() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _placesFuture = ref.read(placesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(placesProvider);

    List<Place> placeList = ref.watch(placesProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your places'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NewPlaceScreen()));
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: _placesFuture,
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : PlacesList(
                          placeList: placeList,
                        ),
            )));
  }
}

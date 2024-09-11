import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_detail.dart';

class PlacesList extends StatelessWidget {
  PlacesList({super.key, required this.placeList});

  final List<Place> placeList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: placeList.length,
        itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundImage: FileImage(placeList[index].image),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PlaceDetailScreen(place: placeList[index])));
              },
              title: Text(
                placeList[index].name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              subtitle: Text(
                placeList[index].location.address,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ));
  }
}

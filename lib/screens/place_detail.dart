import 'package:favorite_places/screens/map.dart';
import 'package:flutter/cupertino.dart';
import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/data/keys.dart';

class PlaceDetailScreen extends StatelessWidget {
  PlaceDetailScreen({required this.place, super.key});

  Place place;

  String get locationImage {
    var api = ApiKeys.yanApi;
    var lon = place.location.longitude;
    var lat = place.location.latitude; //&z=16&size=600,300
    return 'https://static-maps.yandex.ru/v1?lang=ru_RU&ll=$lon,$lat&z=10&size=600,300&apikey=$api';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            place.name,
          ),
        ),
        body: Stack(
          children: [
            Image.file(
              place.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => MapScreen(
                                  location: place.location,
                                  isSelecting: false,
                                )));
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(locationImage),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: Text(
                        place.location.address,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ))
          ],
        ));
  }
}

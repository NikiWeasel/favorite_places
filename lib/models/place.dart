import 'package:uuid/uuid.dart';
import 'dart:io';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.longitude,
    required this.latitude,
    required this.address,
  });

  final double longitude;
  final double latitude;
  final String address;
}

class Place {
  Place(
      {required this.name,
      required this.image,
      required this.location,
      String? id})
      : id = id ?? uuid.v6().toString();

  final String id;
  final String name;
  final File image;
  final PlaceLocation location;
}

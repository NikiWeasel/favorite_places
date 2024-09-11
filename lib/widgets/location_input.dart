import 'dart:math';
import 'package:favorite_places/models/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:favorite_places/screens/map.dart';

import 'package:favorite_places/data/keys.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return LocationInputState();
  }
}

class LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    var api = ApiKeys.yanApi;
    var lon = _pickedLocation!.longitude;
    var lat = _pickedLocation!.latitude; //&z=16&size=600,300
    return 'https://static-maps.yandex.ru/v1?lang=ru_RU&ll=$lon,$lat&z=10&size=600,300&apikey=$api';
  }

  Future<void> _savePlace(double lon, double lat) async {
    const api = ApiKeys.yanApi2;
    final url = Uri.parse(
        'https://geocode-maps.yandex.ru/1.x/?apikey=$api&geocode=$lon,$lat&kind=metro&results=1&format=json');
    final response = await http.get(url);
    final resData = json.decode(response.body);

    late String address;
    if (response.statusCode == 200) {
      // Decode the response body
      final resData = json.decode(response.body);

      // Extract the formatted address
      final featureMember =
          resData['response']['GeoObjectCollection']['featureMember'];

      if (featureMember.isNotEmpty) {
        address = featureMember[0]['GeoObject']['metaDataProperty']
            ['GeocoderMetaData']['Address']['formatted'];
        print('Formatted address: $address');
      } else {
        print('No address found for the given coordinates.');
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    setState(() {
      _pickedLocation =
          PlaceLocation(longitude: lon, latitude: lat, address: address);

      _isGettingLocation = false;
    });
    widget.onSelectLocation(_pickedLocation!);
  }

  void _selectOnMap() async {
    final LatLng? pickedLocation = await Navigator.of(context)
        .push<LatLng>(MaterialPageRoute(builder: (ctx) => const MapScreen()));

    if (pickedLocation == null) {
      return;
    }
    _savePlace(pickedLocation.longitude, pickedLocation.latitude);
  }

  void _getCurrentlocationInput() async {
    Location location = new Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    var lat = locationData.latitude;
    var lon = locationData.longitude;
    _savePlace(lon!, lat!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
    );

    if (_pickedLocation != null) {
      content = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      content = CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          )),
          child: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentlocationInput,
              icon: const Icon(Icons.location_on),
              label: const Text('Get current location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on map'),
            ),
          ],
        )
      ],
    );
  }
}

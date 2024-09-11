import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:favorite_places/widgets/cluster_marker.dart';
import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// import 'package:yandex_mapkit/yandex_mapkit.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location =
        const PlaceLocation(longitude: -122.084, latitude: 37.422, address: ''),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;

  // final ValueNotifier? hitNotifier = ValueNotifier(null);

  // Timer? _timer;

  List<LatLng> _mapPoints = [
    // LatLng(55.755793, 37.617134),
    // LatLng(55.095960, 38.765519),
    // LatLng(56.129038, 40.406502),
    // LatLng(54.513645, 36.261268),
    // LatLng(54.193122, 37.617177),
    // LatLng(54.629540, 39.741809),
  ];

  List<Marker> _getMarkers(List<LatLng> mapPoints) {
    return List.generate(
      mapPoints.length,
      (index) => Marker(
        point: mapPoints[index],
        child: const Icon(
          Icons.location_on,
          size: 50,
          color: Colors.red,
        ),
        width: 50,
        height: 50,
        alignment: Alignment.center,
      ),
    );
  }

  void _onMapTapped(TapPosition tapPosition, LatLng position) {
    setState(() {
      _mapPoints.clear();
      _mapPoints.add(position);
    });
    // print("Map tapped at: ${position.latitude}, ${position.longitude}");
    // Здесь вы можете добавить свой функционал
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    // print(widget.location.latitude.toString() +
    //     ' | ' +
    //     widget.location.longitude.toString());
    _mapPoints.add(LatLng(widget.location.latitude, widget.location.longitude));
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // PlaceLocation? _pickedLocation = widget.location;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your location' : 'Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {},
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pop(_mapPoints[0]);
        },
      ),
      body: GestureDetector(
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter:
                LatLng(widget.location.latitude, widget.location.longitude),
            //48.558687, 135.037996// 55.755793, 37.617134
            initialZoom: 16,
            interactiveFlags: ~InteractiveFlag.doubleTapZoom,
            interactionOptions: InteractionOptions(
                //TODO интерактив
                ),
            onTap: !widget.isSelecting ? null : _onMapTapped,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: _getMarkers(_mapPoints),
            ),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                size: const Size(50, 50),
                maxClusterRadius: 50,
                markers: _getMarkers(_mapPoints),
                builder: (_, markers) {
                  return ClusterMarker(
                    markersLength: markers.length.toString(),
                  );
                },
              ),
            ),
            // RichAttributionWidget(
            //   attributions: [
            //     TextSourceAttribution(
            //       'OpenStreetMap contributors',
            //       onTap: () {},
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

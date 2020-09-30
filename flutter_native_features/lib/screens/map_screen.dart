import 'package:flutter/material.dart';
import '../models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation placeLocation;
  final bool isSelection;

  MapScreen({
    this.placeLocation =
        const PlaceLocation(latitude: 28.5713059, longitude: 77.2108836),
    this.isSelection = false,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _selectedLocation;

  void _selectOnMap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Map"),
        actions: widget.isSelection
            ? [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: _selectedLocation == null
                      ? null
                      : () {
                          Navigator.of(context).pop(_selectedLocation);
                        },
                )
              ]
            : null,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
              widget.placeLocation.latitude, widget.placeLocation.longitude),
          zoom: 16,
        ),
        onTap: widget.isSelection ? _selectOnMap : null,
        markers: _selectedLocation == null
            ? null
            : {Marker(markerId: MarkerId('m1'), position: _selectedLocation)},
      ),
    );
  }
}

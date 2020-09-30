import 'package:flutter/material.dart';
import 'package:flutter_native_features/helper/location_helper.dart';
import 'package:flutter_native_features/models/place.dart';
import 'package:flutter_native_features/screens/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function placeLocation;

  const LocationInput(this.placeLocation);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  Future<void> _getCurrentLocation() async {
    final location = await Location().getLocation();
    final imageUrl = LocationHelper.getLocationImage(
        latitude: location.latitude.toString(),
        longitude: location.longitude.toString());
    setState(() {
      _previewImageUrl = imageUrl;
    });
    widget.placeLocation(PlaceLocation(
      latitude: location.latitude,
      longitude: location.longitude,
    ));
  }

  Future<void> _getMapLocation() async {
    final selectedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => MapScreen(
                  isSelection: true,
                )));
    if (selectedLocation == null) return;
    final imageUrl = LocationHelper.getLocationImage(
        latitude: selectedLocation.latitude.toString(),
        longitude: selectedLocation.longitude.toString());
    setState(() {
      _previewImageUrl = imageUrl;
    });
    widget.placeLocation(PlaceLocation(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? Text('No Location Selected')
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
                onPressed: _getCurrentLocation,
                icon: Icon(Icons.location_on),
                textColor: Theme.of(context).primaryColor,
                label: const Text("Current Location")),
            FlatButton.icon(
                onPressed: _getMapLocation,
                icon: Icon(Icons.map),
                textColor: Theme.of(context).primaryColor,
                label: const Text('On Map')),
          ],
        )
      ],
    );
  }
}

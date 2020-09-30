import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_features/models/place.dart';
import '../providers/great_places.dart';
import '../widgets/location_input.dart';
import 'package:provider/provider.dart';
import '../widgets/image_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static final routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _savedImage;
  PlaceLocation _placeLocation;

  void _saveImage(File saveImage) {
    _savedImage = saveImage;
  }

  void _savePlaceLocation(PlaceLocation location) {
    _placeLocation = location;
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _savedImage == null ||
        _placeLocation == null) return;

    Provider.of<GreatPlaces>(context, listen: false).addPlace(
        _titleController.text.toString(), _savedImage, _placeLocation);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(_saveImage),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(_savePlaceLocation),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            onPressed: _savePlace,
            icon: Icon(Icons.add),
            label: const Text('Add Place'),
            elevation: 0,
            color: Theme.of(context).accentColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          )
        ],
      ),
    );
  }
}

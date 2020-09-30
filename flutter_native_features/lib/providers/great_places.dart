import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_features/helper/db_helper.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _placesList = [];

  List<Place> get items {
    return [..._placesList];
  }

  // this will be used in place detail screen if i will make that
  Place findById(String id) {
    return _placesList.firstWhere((element) => id == element.id);
  }

  void addPlace(String title, File imageFile, PlaceLocation location) {
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        image: imageFile,
        location: location);
    _placesList.add(newPlace);
    notifyListeners();
    DBHelper.insert("places", {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_long': newPlace.location.longitude,
      'address': "Use Http Api google here",
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('places');
    _placesList = dataList.map((item) =>
        Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: PlaceLocation(
                latitude: item['loc_lat'],
                longitude: item['loc_long'],
                address: item['address']
            )
        )).toList();
    notifyListeners();
  }
}

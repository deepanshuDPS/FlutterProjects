import 'package:flutter/material.dart';
import 'screens/add_place_screen.dart';
import 'providers/great_places.dart';
import 'package:provider/provider.dart';
import 'screens/places_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child: MaterialApp(
        title: 'Places App',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
        ),
        home: PlacesListScreen(),
        routes: {
          AddPlaceScreen.routeName : (ctx) => AddPlaceScreen()
        },
      ),
    );
  }
}


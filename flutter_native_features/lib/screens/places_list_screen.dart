import 'package:flutter/material.dart';
import 'package:flutter_native_features/providers/great_places.dart';
import 'package:provider/provider.dart';
import 'add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Places'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (ctx, dataSnapshot) => dataSnapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlaces>(
                  child: Center(
                      child: Text('Sorry there is no places at this time')),
                  builder: (ctx, greatPlaces, ch) => greatPlaces.items.length ==
                          0
                      ? ch
                      : ListView.builder(
                          itemCount: greatPlaces.items.length,
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    FileImage(greatPlaces.items[index].image),
                              ),
                              title: Text(greatPlaces.items[index].title),
                              subtitle: Text(
                                  greatPlaces.items[index].location.address.toString() ),
                              onTap: null,
                            );
                          }),
                ),
        ));
  }
}

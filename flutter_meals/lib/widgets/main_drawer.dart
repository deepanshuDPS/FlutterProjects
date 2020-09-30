import 'package:flutter/material.dart';
import '../screens/category_screen.dart';
import '../screens/filter_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget _buildDrawerItem(IconData icon, String text, Function switchScreen) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        text,
        style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
      onTap: switchScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Theme
                .of(context)
                .accentColor,
            alignment: Alignment.centerLeft,
            child: Text(
              'Cooking Up!!',
              style: TextStyle(
                color: Theme
                    .of(context)
                    .primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _buildDrawerItem(Icons.restaurant, "Meals", () {
            Navigator.of(context).pushReplacementNamed("/");
          }),
          _buildDrawerItem(Icons.settings, "Filters", () {
            Navigator.of(context).pushReplacementNamed(FilterScreen.routeName);
          }),
        ],
      ),
    );
  }
}

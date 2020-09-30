import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import './category_screen.dart';
import './favourite_screen.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {

  final List<Map<String, Object>> _pages = [
    {
      "page": CategoryScreen(),
      "title": "Categories",
      "action": null
    },
    {
      "page": FavouriteScreen(),
      "title": "Favourites"
    }
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index){
   setState(() {
     _selectedPageIndex = index;
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        items: [
         const BottomNavigationBarItem(
              icon: Icon(Icons.category),
              title: Text("Categories")
          ),
         const BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: Text("Favourites")
          )
        ],
      ),
    );
  }
}
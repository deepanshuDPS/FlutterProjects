import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';

class FilterScreen extends StatefulWidget {
  static final routeName = '/filter-screen';

  final bool isVeg;
  final Function saveFilter;

  FilterScreen({this.isVeg,this.saveFilter});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool _isVeg;

  @override
  void initState() {
    _isVeg = widget.isVeg;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        actions: [
          IconButton(
            onPressed: () => widget.saveFilter(_isVeg),
            icon: Icon(Icons.save),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: <Widget>[
          Container(
            child: Text("Filter according to your choice"),
          ),
          Expanded(
            child: ListView(
              children: [
                SwitchListTile(
                  title: Text("Vegetarian"),
                  subtitle: Text('Need Vegetarian Food Only'),
                  value: _isVeg,
                  onChanged: (isChecked) {
                    setState(() {
                      _isVeg = isChecked;
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

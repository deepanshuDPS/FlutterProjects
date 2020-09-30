import 'package:flutter/material.dart';
import 'screens/filter_screen.dart';
import 'screens/tab_screen.dart';
import 'screens/category_screen.dart';

import 'screens/category_meal_screen.dart';
import 'screens/meal_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isVeg = false;

  void saveFilter(bool veg){
    setState(() {
      isVeg = veg;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Meals App',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.amber,
          fontFamily: 'Raleway',
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline6: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ))),
      initialRoute: "/",
      // "/" by Default
      routes: {
        '/': (ctx) => TabScreen(),
        CategoryScreen.routeName : (ctx) => CategoryScreen(),
        FilterScreen.routeName : (ctx) => FilterScreen(isVeg: isVeg,saveFilter:saveFilter,),
        CategoryMealScreen.routeName: (ctx) => CategoryMealScreen(),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen()
      },
      /*onGenerateRoute: (settings) {
        print(settings.arguments);
        if (settings.name == "/...") {
          // switch to perticular screen if route for name is not declared
          return MaterialPageRoute(builder: (ctx) => CategoryScreen());
        } else {
          return MaterialPageRoute(builder: (ctx) => CategoryScreen());
        }
      },*/
      onUnknownRoute: (settings) {
        // when there is no generate route or no mentioned route then
        // redirect to some page or error page
        return MaterialPageRoute(builder: (ctx) => CategoryScreen());
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/products_provider.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { All, FavouritesOnly }

class ProductOverViewScreen extends StatefulWidget {
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _isFavouriteOnly = false;
  var _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      setStatesForPage(true);
      Provider.of<Products>(context, listen: false).fetchAndSetProducts().then((value) {
        setStatesForPage(false);
      });
    }
  }

  void setStatesForPage(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          Consumer<Cart>(
            builder: (_, builder, ch) {
              return Badge(
                child: ch,
                value: builder.itemCount.toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (optionSelected) {
              setState(() {
                if (optionSelected == FilterOptions.All) {
                  _isFavouriteOnly = false;
                } else {
                  _isFavouriteOnly = true;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text("All"), value: FilterOptions.All),
              PopupMenuItem(
                  child: Text("Favourites Only"),
                  value: FilterOptions.FavouritesOnly),
            ],
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_isFavouriteOnly),
      drawer: AppDrawer(),
    );
  }
}

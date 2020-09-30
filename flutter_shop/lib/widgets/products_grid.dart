import 'package:flutter/material.dart';
import '../providers/products_provider.dart';
import 'package:provider/provider.dart';

import 'product_item.dart';

class ProductsGrid extends StatelessWidget {

  final bool isFavourite;

  ProductsGrid(this.isFavourite);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = isFavourite ? productData.favItems : productData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        itemCount: products.length,
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem());
        });
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quatitiy;

  CartItem({
    this.id,
    this.productId,
    this.title,
    this.price,
    this.quatitiy,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          color: Theme.of(context).errorColor,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          alignment: Alignment.centerRight,
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('Are you sure to delete?'),
                  content: Text('This cart item is deleted forever'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text('Yes'),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text('No'),
                    )
                  ],
                );
              });
        },
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        },
        key: ValueKey(id),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text("\$ $price"),
                ),
              ),
            ),
            title: Text(
              "$title",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            subtitle: Text(
              "${price * quatitiy}",
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
            trailing: Text(
              "$quatitiy x",
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
          ),
        ));
  }
}

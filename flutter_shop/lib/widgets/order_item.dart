import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/cart.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _isExpand = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isExpand
          ? min(((widget.order.products) as List<CartItem>).length * 20.0 + 105,
              200)
          : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "\$${widget.order.amount}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                "${widget.order.dateTime}",
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              trailing: IconButton(
                icon: Icon(_isExpand ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _isExpand = !_isExpand;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _isExpand
                  ? min(
                      ((widget.order.products) as List<CartItem>).length *
                              20.0 +
                          10,
                      100)
                  : 0,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  height: min(
                      ((widget.order.products) as List<CartItem>).length *
                              20.0 +
                          10,
                      100),
                  child: ListView(
                      children: ((widget.order.products) as List<CartItem>)
                          .map((prod) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    prod.title,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${prod.quantity}x",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ))
                          .toList())),
            )
          ],
        ),
      ),
    );
  }
}

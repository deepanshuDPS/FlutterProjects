import 'package:flutter/material.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' as ord;
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static final routeName = "/orders";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _ordersFuture;

  Future _obtainOrderFuture() {
    return Provider.of<ord.Order>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      drawer: AppDrawer(),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (dataSnapshot.error == null) {
              return Consumer<ord.Order>(
                builder: (ctx, orderData, child) {
                  return ListView.builder(
                    itemBuilder: (ctx, index) {
                      return OrderItem(
                        order: orderData.items[index],
                      );
                    },
                    itemCount: orderData.items.length,
                  );
                },
              );
            } else {
              return Center(child: Text("Some error!!"));
            }
          },
        ),
      ),
    );
  }
}

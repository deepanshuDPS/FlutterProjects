import 'package:flutter/material.dart';
import './transaction_item.dart';
import '../models/transaction.dart';

class Transactions extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  Transactions(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 500,
        child: transactions.isEmpty
            ? LayoutBuilder(
                builder: (ctx, constraints) {
                  return Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("You have no transactions yet",
                            style: Theme.of(context).textTheme.headline6),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: constraints.maxHeight * 0.6,
                          child: Image.asset(
                            "assets/images/empty.png",
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
            : ListView(
                children: transactions
                    .map((txn) => TransactionItem(
                        key: ValueKey(txn.id),
                        transaction: txn,
                        deleteTransaction: deleteTransaction))
                    .toList(),
              ));
  }
}

/*
*  Row(
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2)),
                        child: Text(
                          "\$ ${transactions[index].amount.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 20),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            transactions[index].title,
                            style: Theme.of(context).textTheme.title,
                          ),
                          Text(
                            DateFormat.yMMMd()
                                .format(transactions[index].dateTime),
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  )*/

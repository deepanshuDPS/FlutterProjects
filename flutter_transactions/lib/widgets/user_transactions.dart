import 'package:flutter/material.dart';
import 'package:flutter_transactions/widgets/new_transactions.dart';
import '../models/transaction.dart';
import '../widgets/new_transactions.dart';
import '../widgets/transactions_list.dart';

class UserTransactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<UserTransactions> {
  final List<Transaction> _transactions = [
    Transaction(
        id: "i1", title: "Ball", amount: 20.00, dateTime: DateTime.now()),
    Transaction(
        id: "i2", title: "Badminton", amount: 420.00, dateTime: DateTime.now())
  ];

  void _addTxn(String title, double amount) {
    Transaction txn = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        dateTime: DateTime.now());

    setState(() {
      _transactions.add(txn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NewTransaction(_addTxn),
        Transactions(_transactions,null)],
    );
  }
}

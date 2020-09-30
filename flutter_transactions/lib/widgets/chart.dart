import 'package:flutter/material.dart';
import './chart_bar.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';


class Chart extends StatelessWidget {
  List<Transaction> transactions;

  Chart(this.transactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var total = 0.0;
      for (var txn in transactions) {
        if (txn.dateTime.weekday == weekDay.weekday &&
            txn.dateTime.month == weekDay.month &&
            txn.dateTime.year == weekDay.year) total += txn.amount;
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': total
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues.toString());
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((value) {
            return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  value['day'],
                  value['amount'],
                  totalSpending == 0
                      ? 0.0
                      : (value['amount'] as double) / totalSpending,
                ));
          }).toList(),
        ),
      ),
    );
  }
}

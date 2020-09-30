import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_transactions/widgets/new_transactions.dart';
import './widgets/transactions_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  /*WidgetsFlutterBinding.ensureInitialized(); // sometimes required before calling the app in test
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      theme: ThemeData(
          primaryColor: Colors.lightGreen,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              button: TextStyle(
                color: Colors.white,
              )),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactions = [
    /*Transaction(
        id: "i1", title: "Ball", amount: 20.00, dateTime: DateTime.now()),
    Transaction(
        id: "i2", title: "Badminton", amount: 420.00, dateTime: DateTime.now())*/
  ];


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("AppState"+state.toString());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print("initState Main");
  }



  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print("dispose Main");
  }

  bool _switchOn = false;

  void _addTxn(String title, double amount, DateTime selectedDate) {
    Transaction txn = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        dateTime: selectedDate);

    setState(() {
      _transactions.add(txn);
    });
  }

  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.dateTime.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
            onTap: () => {},
            child: NewTransaction(_addTxn),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((txn) => txn.id == id);
    });
  }

  List<Widget> _buildLandscapeWidgets(
      MediaQueryData mediaQuery, AppBar appBar, Widget txnList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Show Chart"),
          Switch(
            value: _switchOn,
            onChanged: (val) {
              setState(() {
                _switchOn = val;
              });
            },
          )
        ],
      ),
      _switchOn
          ? Container(
              height: mediaQuery.size.height * 0.6 -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top,
              child: Chart(_recentTransactions))
          : txnList
    ];
  }

  List<Widget> _buildPortraitWidgets(
      MediaQueryData mediaQuery, AppBar appBar, Widget txnList) {
    return [
      Container(
          height: mediaQuery.size.height * 0.3 -
              appBar.preferredSize.height -
              mediaQuery.padding.top,
          child: Chart(_recentTransactions)),
      txnList
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text("Personal Expenses"),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );

    final mediaQuery = MediaQuery.of(context);

    final txnList = Container(
        height: mediaQuery.size.height * 0.7 -
            appBar.preferredSize.height -
            mediaQuery.padding.top,
        child: Transactions(_transactions, _deleteTransaction));

    var isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeWidgets(
                mediaQuery,
                appBar,
                txnList,
              ),
            if (!isLandscape)
              ..._buildPortraitWidgets(
                mediaQuery,
                appBar,
                txnList,
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTxn;

  NewTransaction(this.addTxn){
    print("NewTransaction constructor");
  }

  @override
  _NewTransactionState createState(){
    print("NewTransaction createState");
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime _selectedDate;

  @override
  void initState() {
    print("initState Transaction");
    super.initState();
  }

  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    print("didUpdateWidget Transaction");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print("dispose Transaction");
    super.dispose();
  }

  void _submitText() {
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    if (title.isEmpty || amount < -1 || _selectedDate == null) return;

    widget.addTxn(title, amount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _chooseDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) return;
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Card(
            elevation: 5,
            child: Container(
              margin: EdgeInsets.only(
                  top: 10,
                  right: 10,
                  left: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: "Title"),
                    controller: _titleController,
                    onSubmitted: (_) => _submitText(),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Amount"),
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _submitText(),
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(_selectedDate == null
                              ? "No Date chosen"
                              : "Picked Date: ${DateFormat.yMd().format(_selectedDate)}"),
                        ),
                        FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            "Choose date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: _chooseDate,
                        )
                      ],
                    ),
                  ),
                  RaisedButton(
                    child: Text("Add Transaction"),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.button.color,
                    onPressed: _submitText,
                  )
                ],
              ),
            )));
  }
}

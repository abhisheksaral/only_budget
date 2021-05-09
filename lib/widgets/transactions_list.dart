import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:only_budget/models/transaction_model.dart';
import 'package:http/http.dart' as http;

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {

  List<Widget> _transactionTiles = [];
  final _listKey = GlobalKey<AnimatedListState>();

  void saveExpense() async {

    var transaction = Transaction(
        title: "PS Plus",
        category: "Subscription",
        amount: 9.95
    );

    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:8083/expense'));
    request.body = '''{\r\n    "title": "Apple Store",\r\n    "category": "Shopping",\r\n    "amount": 300.2,\r\n    "date": "05/03/2021"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

  void getExpense() async {
    var request = http.Request('GET', Uri.parse('http://localhost:8083/expense/62c12a74-5318-4042-96d9-ab13393abf6a'));
    request.body = '''''';

    http.StreamedResponse streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print(response.body);
      var jsonData = json.decode(response.body);
      Transaction a = Transaction(title: jsonData['title'], category: jsonData['category'], amount: jsonData['amount'], icon: Icon(Icons.shopping_cart_outlined));
      _transactionTiles.add(_buildTile(a));
      _listKey.currentState.insertItem(_transactionTiles.length - 1);
    }
    else {
    print(response.reasonPhrase);
    }
  }


  _addTransactions() {
    List<Transaction> _transactions = [
      Transaction(
          title: 'Xfinity Charges',
          amount: 200.02,
          category: 'Utility Charges',
          icon: Icon(Icons.receipt_long)
      ),
    ];

    _transactions.forEach((Transaction transaction) {
      _transactionTiles.add(_buildTile(transaction));
      _listKey.currentState.insertItem(_transactionTiles.length - 1);
    });
  }

  Widget _buildTile(Transaction transaction) {



    return ListTile(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => Details(trip: trip)));
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
        child: Text(transaction.title),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
        child: Text(transaction.category),
      ),
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.deepPurpleAccent,
        ),
        child: transaction.icon != null ? transaction.icon: Icon(Icons.attach_money),
      ),
      trailing: Text(
        '\$${transaction.amount}',
        style: TextStyle(fontSize: 18, color: Colors.amberAccent)
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addTransactions();
    });

  }

  Tween<Offset> _offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text('Recent expenses',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
            Spacer(),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 15, 0),
                child: HoverButton(
                  color: Colors.grey[50],
                  onpressed: () => getExpense(),
                  child: Icon(
                    Icons.add,
                    size: 35,
                    color: Colors.grey[850],
                  ),
                  height: 60,
                  minWidth: 130,
                  shape: StadiumBorder(),
                  hoverColor: Color.fromRGBO(32, 148, 243, 0.3),
                  hoverElevation: 20,

                )
            )
          ],
        ),
        Expanded(
          child: AnimatedList(
              key: _listKey,
              initialItemCount: _transactionTiles.length,
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: animation.drive(_offset),
                  child: _transactionTiles[index],
                );
              }),
        )
      ],
    );
  }
}

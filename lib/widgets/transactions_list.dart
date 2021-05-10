import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hovering/hovering.dart';
import 'package:only_budget/models/transaction_model.dart';
import 'package:http/http.dart' as http;
import 'package:select_form_field/select_form_field.dart';

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {

  List<Widget> _transactionTiles = [];
  final _listKey = GlobalKey<AnimatedListState>();
  final titleInput = TextEditingController();
  final categoryInput = TextEditingController();
  double amountInput;


  List<Transaction> _transactions = [];


  void saveExpense(String title, String category, double amount) async {

    Icon icon;
    if (category == 'Utility Charges') {
      icon = Icon(Icons.electrical_services_outlined);
    } else if (category == 'Shopping') {
      icon = Icon(Icons.shopping_cart_outlined);
    } else if (category == 'Grocery') {
      icon = Icon(Icons.dinner_dining);
    } else if (category == 'Others') {
      icon = Icon(Icons.attach_money);
    } else if (category == 'Subscription') {
      icon = Icon(Icons.receipt_long);
    }

    DateTime now = DateTime.now();
    var transaction = Transaction(
        title: title,
        category: category,
        amount: amount,
        date: now,
        icon: icon
    );

    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*'
    };
    var request = http.Request('POST', Uri.parse('http://expensetrackerapi-env.eba-bxptibyw.us-east-1.elasticbeanstalk.com/expense'));
    request.body = '''{\r\n    "title": "${title}",\r\n    "category": "${category}",\r\n    "amount": ${amount},\r\n    "date": "${now.toString()}"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      _transactionTiles.add(_buildTile(transaction));
      _listKey.currentState.insertItem(_transactionTiles.length - 1);
      titleInput.clear();
      print(await response.stream.bytesToString());
      Navigator.of(context).pop();
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
      _controller = TextEditingController(text: 'Utility Charges');
      _getValue();
  }

  Tween<Offset> _offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));

  TextEditingController _controller;
  //String _initialValue;
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';

  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Utility Charges',
      'label': 'Utility Charges',
      'icon': Icon(Icons.electrical_services_outlined),
    },
    {
      'value': 'Shopping',
      'label': 'Shopping',
      'icon': Icon(Icons.shopping_cart_outlined),
    },
    {
      'value': 'Grocery',
      'label': 'Grocery',
      'icon': Icon(Icons.dinner_dining),
    },
    {
      'value': 'Others',
      'label': 'Others',
      'icon': Icon(Icons.attach_money),
    },
    {
      'value': 'Subscription',
      'label': 'Subscription',
      'icon': Icon(Icons.receipt_long),
    },
  ];

  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        //_initialValue = 'circleValue';
        _controller?.text = 'circleValue';
      });
    });
  }

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
                  onpressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Container(
                            height: screenSize.height/2,
                            width: screenSize.width/2,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      child: Text('Title',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: TextField(
                                          controller: titleInput,
                                          decoration: InputDecoration(
                                            hintText: 'e.g. Netflix, Internet Charges, Walmart'
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      child: Text('Category',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SelectFormField(
                                        //type: SelectFormFieldType.dialog,
                                        //initialValue: _initialValue,
                                        icon: Icon(Icons.format_shapes),
                                        changeIcon: true,
                                        dialogTitle: 'Pick a category',
                                        dialogCancelBtn: 'CANCEL',
                                        enableSearch: true,
                                        dialogSearchHint: 'Search item',
                                        items: _items,
                                        onChanged: (val) => setState(() => _valueChanged = val),
                                        validator: (val) {
                                          setState(() => _valueToValidate = val ?? '');
                                          return null;
                                        },
                                        onSaved: (val) => setState(() => _valueSaved = val ?? ''),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      child: Text('Amount',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          decoration: InputDecoration(
                                              hintText: 'e.g. 11.4, 55'
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              amountInput = double.parse(value);
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            print(titleInput.text);
                                            print(_valueChanged);
                                            print(amountInput);
                                            saveExpense(titleInput.text, _valueChanged, amountInput);

                                          },
                                          child: Text('Save Expense'),
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(200,50)
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
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

import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:only_budget/models/transaction_model.dart';

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {

  List<Widget> _transactionTiles = [];
  final _listKey = GlobalKey<AnimatedListState>();

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
                  onpressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Container(
                            height: screenSize.height/2,
                            width: screenSize.width/2,
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

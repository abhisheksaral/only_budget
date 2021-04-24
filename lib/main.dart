import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hovering/hovering.dart';
import 'package:only_budget/widgets/transactions_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        canvasColor: Colors.grey[900],
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 180),
        child: AppBar(
          elevation:8.0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 20),
                    CircleAvatar(
                      backgroundImage: AssetImage('graphics/jin_sakai.png'),
                      radius: 65,
                    ),
                    SizedBox(width: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello, Abhishek',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Dashboard',
                          style: TextStyle(
                            fontSize: 40
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                          child: Text('Summary',
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
                            onpressed: () { print('Add Button Clicked'); },
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
                    )
                  ],
                ),
              )
          ),
          VerticalDivider(
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            flex: 3,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                      child: Text('Recent expenses',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Expanded(
                        child: TransactionList(),
                    )
                  ],
                ),
              )
          )
        ],
      )
    );
  }
}

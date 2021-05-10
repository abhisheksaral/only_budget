import 'package:flutter/material.dart';
import 'package:only_budget/widgets/transactions_list.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Only Budget',
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

    //placeholder pie chart data
    //for some reason the colors don't update, it uses the default colors that the example code had
    final List<PieChartData> chartData = [
      PieChartData('Subscriptions', 25, Colors.pinkAccent),
      PieChartData('Utilities', 38, Colors.deepPurpleAccent),
      PieChartData('Other', 34, Colors.lightBlueAccent),
      PieChartData('Groceries', 52, Color.fromRGBO(255,189,57,1)) //how the example code defined the color
    ];

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
                        ],
                      ),

                      // For the Income/Chart boxes
                      Row(
                        children:[

                          //Income & spending card
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 15, 0),
                            child: incomeCard(),
                          ),
                          Spacer(),

                          //pie chart card
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 15, 0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: SizedBox(
                                  width: 330,
                                  height: 200,
                                  child: SfCircularChart(
                                      legend: Legend(isVisible: true),
                                      series: <CircularSeries>[
                                        DoughnutSeries<PieChartData, String>(
                                            legendIconType: LegendIconType.circle,
                                            dataSource: chartData,
                                            xValueMapper: (PieChartData data, _) => data.x,
                                            yValueMapper: (PieChartData data, _) => data.y,
                                            dataLabelSettings: DataLabelSettings(isVisible: true)),
                                      ]
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),

                      //Bar chart
                      Row(
                        children: [
                          Container(
                              padding: const EdgeInsets.fromLTRB(20, 20, 15, 0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: SizedBox(
                                  width: 600,
                                  height: 300,
                                  child: SfCartesianChart(
                                      title: ChartTitle(text: 'Overview'),
                                      primaryXAxis: CategoryAxis(),
                                      primaryYAxis: NumericAxis(),
                                      series: <ChartSeries>[
                                        ColumnSeries<BarChartData, String>(
                                          borderRadius: BorderRadius.circular(10),
                                          dataSource: getBarChartData(),
                                          xValueMapper: (BarChartData data, _) => data.x,
                                          yValueMapper: (BarChartData sales, _) => sales.y,
                                        )
                                      ]
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
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


class PieChartData {
  PieChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color color;
}

class BarChartData {
  String x;
  double y;
  BarChartData(this.x, this.y);
}

dynamic getBarChartData(){
  //placeholder values
  List<BarChartData> columnData = <BarChartData> [
    BarChartData("April", 20),
    BarChartData("May", 30),
    BarChartData("June", 40)
  ];

  return columnData;
}

//Styling & Formatting for the Income/Spending Card
Card incomeCard(){
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: SizedBox(
      width: 330,
      height: 200,
      child: Column(children: [
        Row(children: [
          Container(
            child: Text(
              'Income',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            margin: EdgeInsets.all(25),
          ),
          Spacer(),
          Container(
            child: Text(
              'Spending',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            margin: EdgeInsets.all(25),
          ),
        ]),
        Row(
          children: [
            Container(
              child: Icon(
                Icons.arrow_circle_up,
                color: Colors.green,
                size: 40,
              ),
              margin: EdgeInsets.all(10),
            ),
            Container(
              child: Text(
                '\$6000',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            Spacer(),
            Container(
              child: Icon(
                Icons.arrow_circle_down,
                color: Colors.red,
                size: 40,
              ),
              margin: EdgeInsets.all(10),
            ),
            Container(
              child: Text(
                '\$2000',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
            ),
          ],
        ),
      ]),
    ),
  );
}
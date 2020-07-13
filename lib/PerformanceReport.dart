import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sahanddriver/PerformanceReportBody.dart';

class Performance extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PerformanceState();
  }

}

class PerformanceState extends State<Performance> with SingleTickerProviderStateMixin{

  static TabController tabController;


  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
  }

  final appbar = AppBar(
    backgroundColor: Color(0xff008860),
    title: new Text('نمودار عملکرد',style: TextStyle(color: Colors.white,fontSize: 18),),
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: appbar,
      body: Column(
        children: <Widget>[
          new TabBar(
              labelColor: Colors.black,
              controller: tabController,
              indicatorColor: Colors.black45,
              tabs: <Widget>[
                new Tab(text: "هفتگی"),
                new Tab(text: "ماهانه"),
                new Tab(text: "سالانه")
              ]
          ),
          Expanded(
            child:
            new TabBarView(
                controller: tabController,
                children: <Widget>[
                  PerformanceReportBody(),
                  PerformanceReportBody(),
                  PerformanceReportBody()
                ]
            ),
          )

        ],
      ),
    );
  }

}
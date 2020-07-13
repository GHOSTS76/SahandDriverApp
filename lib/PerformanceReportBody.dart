
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PerformanceReportBody extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PrBodyState();
  }

}

class PrBodyState extends State<PerformanceReportBody>{
  static TabController tabController;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: new Text('sallaaam'),
      ),
    );
  }

}
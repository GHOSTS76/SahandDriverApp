import 'package:flutter/material.dart';
import 'profile_driver.dart';
import 'profile_car.dart';
class Profile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }

}

class ProfileState extends State<Profile> with SingleTickerProviderStateMixin{
  static TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor:  Color(0xff008860),
        title: new Text('پروفایل',style: TextStyle(fontSize: 20,color: Colors.white),),
      ),
      body: Column(
        children: <Widget>[
          new TabBar(
              labelColor: Colors.black,
              controller: tabController,
              indicatorColor: Colors.black45,
              tabs: <Widget>[
                new Tab(text: "ماشین"),
                new Tab(text: "راننده")
              ]
          ),
          Expanded(
            child:
            new TabBarView(
              controller: tabController,
              children: <Widget>[
                new  profliecar(),
                new profliedriver()
              ]),)

        ],
      )

    );
  }

}
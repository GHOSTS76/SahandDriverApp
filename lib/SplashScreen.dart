import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sahanddriver/MainRequestAccept.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pl_notifications/pl_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashScreenState();
  }

}
class SplashScreenState extends State<SplashScreen> {
  String LoginState;

  StartTime() {
    var duration = new Duration(seconds: 5);
    return new Timer(duration, checkLogin);
  }

  @override
  void initState() {
    super.initState();

    deletprefs();

  }


  navigationPage(Page) {
    Navigator.of(context).pushNamed('/' + Page);
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('IsLogedIn');
    var intravel = prefs.getString('Intravel');
    LoginState = stringValue;
    if (LoginState == "True") {
      if (intravel == "True") {
        GetResumeData();
      } else if (intravel == 'False' || intravel == null) {
        navigationPage('HomePage');
      }
    } else {
      print('not true');
      navigationPage('InputNumber');
    }
  }

  checkLogin() async {
    getStringValuesSF();
  }

  deletprefs() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('Intravel');
    //   prefs.remove('Stage');
    //   prefs.remove('DownBtnText');
    //  prefs.remove('Passengerid');
    //  prefs.remove('OriginStr');
    //   prefs.remove('DestinationStr');
    // prefs.remove('StartPoint');
    //  prefs.remove('EndPoint');
    // prefs.remove('SecondLocation');
    // prefs.remove('TripIdStr');
    //   prefs.remove('BackAndForthStr');
    StartTime();
  }
  GetResumeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var Passengerid = prefs.getString('Passengerid');
    var OriginStr = prefs.getString('OriginStr');
    var DestinationStr = prefs.getString('DestinationStr');
    var StartPoint = prefs.getString('StartPoint');
    var EndPoint = prefs.getString('EndPoint');
    var SecondLocation = prefs.getString('SecondLocation');
    var sid = prefs.getString('sid');
    var TripIdStr = prefs.getString('TripIdStr');
    var BackAndForthStr = prefs.getString('BackAndForthStr');
    print('Values ><');
    print('OriginStr' + OriginStr);
    print('DestinationStr' + DestinationStr);
    print('Passengerid' + Passengerid);
    print('StartPoint' + StartPoint);
    print('EndPoint' + EndPoint);
    print('SecondLocation' + SecondLocation);
    print('TripIdStr' + TripIdStr);
    print('BackAndForthStr' + BackAndForthStr);
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
    new Directionality(textDirection: TextDirection.rtl,
      child: new Directionality(textDirection: TextDirection.rtl, child:
      MainRequestAccept(
          OriginStr,
          DestinationStr,
          StartPoint,
          EndPoint,
          TripIdStr,
          SecondLocation,
          BackAndForthStr,
          Passengerid,
          sid)),)));
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(child: Scaffold(
        body: new Stack(
          children: <Widget>[
            new Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/splash.png'),
                      fit: BoxFit.fill)
              ),
            ),
            new Align(
                alignment: Alignment.bottomCenter,
                child: Padding(padding: EdgeInsets.only(bottom: 10.0),
                  child: new CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Colors.amber),
                  ),
                )
            )
          ],
        )
    ), onWillPop: () => Future(() => false))
    ;
  }
}

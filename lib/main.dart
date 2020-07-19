import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sahanddriver/EndTravel.dart';
import 'package:sahanddriver/InputNumber.dart';
import 'package:sahanddriver/MainRequestAccept.dart';
import 'package:sahanddriver/PerformanceReport.dart';
import 'package:sahanddriver/Profile.dart';
import 'package:sahanddriver/SplashScreen.dart';
import 'package:sahanddriver/TravelHistory.dart';
import 'package:sahanddriver/TravelRequest.dart';
import 'package:sahanddriver/setting.dart';
import 'package:sahanddriver/startofwork.dart';
import 'package:sahanddriver/verify_number.dart';
import 'package:sahanddriver/wallet.dart';
import 'HomePage.dart';
import 'TravelHistotyDetails.dart';

void main() => runApp(Sahand());

class Sahand extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'سهند',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primaryIconTheme: IconThemeData(color: Colors.green),
          primaryTextTheme: TextTheme(title: TextStyle(color: Colors.black))
      ),
      initialRoute: "/SplashScreen",
      routes: {
        "/SplashScreen" : (context) =>  new Directionality(textDirection: TextDirection.rtl, child:  SplashScreen()),
        "/HomePage" : (context) => new Directionality(textDirection: TextDirection.rtl, child:  HomePage()),
        "/Setting" : (context) => new Directionality(textDirection: TextDirection.rtl, child:  Setting()),
        "/Profile" : (context) => new Directionality(textDirection: TextDirection.rtl, child:  Profile()),
        "/InputNumber" : (context) => new Directionality(textDirection: TextDirection.rtl, child:  verify_number()),
        "/VerifyNumber" : (context) => new Directionality(textDirection: TextDirection.rtl, child:  input_Number('0',0,'0')),
        "/TravelHistory" : (context) => new Directionality(textDirection: TextDirection.rtl, child:  TravelHistory()),
        "/Wallet" : (context) => new Directionality(textDirection: TextDirection.rtl, child:  Wallet()),
        "/StartOfWork" : (context) => new Directionality(textDirection: TextDirection.rtl, child:  StartOfWork()),
        "/EndTravel" : (context) => new Directionality(textDirection: TextDirection.rtl, child:  EndTravel('id')),
        "/TravelHistoryDetails" : (context) => new Directionality(textDirection: TextDirection.rtl, child:  TravelDetails('0')),
        "/TravelRequest" : (context) => new Directionality(textDirection: TextDirection.rtl, child:  TravelRequest('0')),
        "/PerformanceReport" : (context) => new Directionality(textDirection: TextDirection.rtl, child:  Performance()),
        "/MainRequestAccept" : (context) => new Directionality(textDirection: TextDirection.rtl, child:  MainRequestAccept('Def','Def',0.0,0.0,'id','0','0','0','0','0')),
      },
    );
  }
}

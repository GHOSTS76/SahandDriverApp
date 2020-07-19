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
  var dio;
  String Token;
  String Numbr;
  String IsloggedIn;
  String NatCode;
  StartTime() {
    var duration = new Duration(seconds: 5);
    return new Timer(duration, checkLogin);
  }

  @override
  void initState() {
    super.initState();


    dio = Dio()..interceptors.add(RetryInterceptor(
        options: const RetryOptions(
          retries: 2, // Number of retries before a failure
          retryInterval: const Duration(seconds: 10), // Interval between each retry
        )
    ));
    FirstFunc();

  }
  navigationPage(Page) {
    Navigator.of(context).pushNamed('/' + Page);
  }
  DeterminePage() async {
    if(IsloggedIn == 'True'){
      SelectActiveRide(NatCode,Token);
    }else{
      navigationPage('InputNumber');
    }
  }
  checkLogin() async {
    DeterminePage();
  }
  FirstFunc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Numbr = prefs.getString('UserNumber');
    Token = prefs.getString('UserToken');
    NatCode=  prefs.getString('NationalCode');
    IsloggedIn = prefs.getString('IsLogedIn');
    StartTime();
  }
  GetResumeData(PassengerId,OriginStr,DestinationStr,StartPoint,EndPoint,SecondLocation,TripIdStr,BackAndForthStr,Stage,DownBtnText) async {
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
        PassengerId,
          Stage,
          DownBtnText
      )),)));
  }
  SelectActiveRide(DriverID,UserToken) async {

    print(DriverID);
    print(UserToken);

    FormData formData = FormData.fromMap({
      "DriverID":DriverID,
      "UserTokenCheck":UserToken,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/Ride/GetActiveRidesDriver",data:formData);
      print(response.data.toString());
      if(response.data.toString() == 'NoActiveRide'){
        navigationPage('HomePage');
      }else if(response.data.toString() == 'TokenIsOffline'){
        Fluttertoast.showToast(
            msg: "توکن منقضی شده است.لطفا دوباره وارد شوید.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        navigationPage('InputNumber');
      }else{
        var Stage;
        var DownBtnText;
        Stage =  response.data['status'];
        print('Status : '+Stage);
        if(Stage == '0'){
          Stage ='0';
          DownBtnText = 'من رسیدم';
        }
        else if(Stage == '1'){
          Stage ='1';
          DownBtnText = 'مسافر سوار شد';
        }else if(Stage =='2'){
          print('Status two : '+Stage);
          var BackAndForthStr = response.data['BackAndForth'].toString();
          print('BackAndForth '+BackAndForthStr);
          if(BackAndForthStr == '0'){
            DownBtnText = 'پایان سفر';
            Stage ='2';
          }else{
            DownBtnText = 'بازگشت به مبدا';
            Stage ='4';
          }
        }else if(Stage =='3'){
          DownBtnText = 'بازگشت به مبدا';
          Stage ='4';
        }else if(Stage =='4'){
          print('Stage four Rans');
          var PassengerScore = response.data['PassengerScore'].toString();
          print('PassengerScore  '+ PassengerScore);
          if(PassengerScore == 'NULL' || PassengerScore == 'null'){
            print('LAPAI');
            Stage ='6';
            DownBtnText = 'پایان سفر';
          }
        }
        print('Stage Here : '+Stage);
        print('BtnTxt : '+Stage);
        GetResumeData(response.data['passenger_id'],response.data['StartAddress'],response.data['EndAddress'],response.data['start_lat_lng'],response.data['dest_lat_lng'],response.data['extra_destinations'],response.data['id'],response.data['BackAndForth'].toString(),Stage,DownBtnText);
      }
    } catch (e) {
      print(e);
    }
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

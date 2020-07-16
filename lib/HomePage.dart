import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sahanddriver/startofwork.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'DrawerLayout.dart';

class HomePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MyHomePageState();
  }
}
class MyHomePageState extends State<HomePage> {
  Future _future;
  var Name,number,PicrureUrl;
  var natcode;
  var dio;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future  =GetDriverData();
    dio = Dio()..interceptors.add(RetryInterceptor(
          options: const RetryOptions(
            retries: 2, // Number of retries before a failure
            retryInterval: const Duration(seconds: 10), // Interval between each retry
          )
      ));
    SetDriverIsOnline('1');
  }
  @override
  void dispose() {
    SetDriverIsOnline('0');
    super.dispose();
  }

  final appbar = new AppBar(
    backgroundColor:new Color(0xffffffff),
    elevation: 6.0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(right: 1),child: new Text('پایان کار',style: TextStyle(color: Colors.black,fontSize: 20),),),
        Flexible(child:new Text('ارتباط با سرور \nوصل است',style: TextStyle(color: Colors.green,fontSize: 16),maxLines: 2,),
      ),
      ],
    )
  );
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return WillPopScope(child: Scaffold(
      body: new FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData? new Scaffold(
              body:Center(
                child:
                Padding(padding: EdgeInsets.only(top: 20),child: new Align(alignment: Alignment.topCenter,child:new Align(alignment: Alignment.topCenter,child:
                Column(

                  children: <Widget>[
                    new Align(
                      alignment: Alignment.topCenter,
                      child: new Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: EdgeInsets.all(10),
                        elevation: 5,
                        child:
                        Container(
                          height: 50,
                          width: 400,
                          color:  Color(0xff00bfa5),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(right: 10),child:   Image.asset('assets/images/coin.png',height: 40,width: 40,),),
                              new Text('تعداد سکه',style:TextStyle(fontSize: 18,color: Colors.white),),
                              Image.asset('assets/images/navibefire.png'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    new Align(
                      alignment: Alignment.center,
                      child:new Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin: EdgeInsets.all(10),
                          elevation: 5,
                          child:InkWell(onTap:(){
                            GetToken();
                            },
                            child: Container(
                            height: 150,
                            width: 350,
                            color:  Color(0xff98ff98),
                            child: Center(
                              child:
                             Container(
                                  child: Center(
                                    child: new Text('شروع به کار ',style: TextStyle(color: Colors.white,fontSize: 20),),
                                  ),
                                  width: 330,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    color:  Color(0xff4cc417),
                                    border: Border.all(width: 2,color: const Color(0xff347c2c),),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ) ,
                            ),
                          ),)
                      ),
                    )
                  ],
                )
                ),)
                ),
              ),
              drawer: BuildDrawerLayout(context,Name,number,PicrureUrl,'شروع به کار'),
            appBar: appbar,
            ///start building your widget tree
          ):new Center(child: CircularProgressIndicator(),) ;
        },),
    ), onWillPop: () => Future(() => false));
  }
  Future GetDriverData() async {
    print('GetdriverData Runs');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Numbr = prefs.getString('UserNumber');
    print('MNNN'+Numbr);
      FormData formData = FormData.fromMap({
        "Number":Numbr,
      });
      try {
        Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/GetDriverData",data:formData);
        print(response.data);
        print(response.data['FName']);
        print( response.data['MobileNo']);
        if(response.data == null || response.data =='Err'){
          Name ='NotRegistred';
        }else{
          Name = response.data['FName'] +' '+response.data['LName'];
          number = response.data['MobileNo'];
          PicrureUrl = response.data['PicURL'];
          SaveNatCode(response.data['NationalNo']);

        }
      } catch (e) {
        print(e);
      }
      return Name;
  }

  SaveNatCode(NationalCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    natcode = NationalCode;
    prefs.setString('NationalCode',NationalCode);

  }
  void _openLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black26,
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),

                  Padding(padding: EdgeInsets.only(top: 20,left: 10),child:  Text('لطفا صبر کنید',style: TextStyle(fontSize: 20,color: Colors.white,fontFamily: 'IRANSans'),),)

                ],
              )
          ),
        );
      },
    );
  }

  SetDriverIsOnline(IsOnline) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   var NatCode = prefs.getString('NationalCode');
    FormData formData = FormData.fromMap({
      "Driverid": NatCode,
      "DriverIsOnline":IsOnline,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/UpdateDriverOnlineState", data: formData);
      print(response);
      if(response.data.toString() == 'Updated'){

      }
      return true;
    } catch (e) {
      print(e);
    }
  }

  UpdateTravelStateoff(State) async {
    _openLoadingDialog(context);
    print(natcode);
    print(State);
    FormData formData = FormData.fromMap({
      "DriverID":natcode,
      "State":State,
    });
    try {
      Response response = await dio.post('https://sahandtehran.ir:3000/DriverMain/UpdateDriverReadyToWork',data:formData);
      print('UpdateDriver'+response.toString());
      if(response.toString() =='Updated'){
        print('UpdateIntravelState');
        StartWorking();
      }
    } catch (e) {
      print(e);
    }
  }

  StartWorking() async {

    FormData formData = FormData.fromMap({
      "State": '1',
      "MobileNo":number,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/VecInout", data: formData);
      print(response);
      if(response.data.toString() == 'Done'){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  StartOfWork())),(Route<dynamic> route) => true);
      }
      return true;
    } catch (e) {
      print(e);
    }
  }

  checkToken(Token) async {
    print('_checkTokensTARTED-->'+Token);
    FormData formData = FormData.fromMap({
        "UserTokenCheck":Token,

    });
    try {
      Response response = await Dio().post(
          "https://sahandtehran.ir:3000/Token/CheckToken", data: formData,
          options: Options(
            extra: RetryOptions(
              retries: 0,
              retryInterval: const Duration(seconds: 1000),
            ).toExtra(),
          ));
      print('_checkTokenSplash-->' + response.data.toString());

      if (response.data.toString() == 'TokenIsOnline') {
        UpdateTravelStateoff(1);
      } else {
        Fluttertoast.showToast(
            msg: "توکن منقضی شده است.لطفا دوباره وارد شوید.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        LogOut();
      }
    } catch (e) {
      print("ErrorTokenCheck" + e.toString());
    }

  }

  GetToken() async {
    print('Gettoken');
    print(number);
    FormData formData = FormData.fromMap({
        "Number":number,
    });
    try {
      Response response = await Dio().post(
          "https://sahandtehran.ir:3000/Token/GetTokenByPhone", data: formData,
          options: Options(
            extra: RetryOptions(
              retries: 0,
              retryInterval: const Duration(seconds: 1000),
            ).toExtra(),
          ));
      if (response.data.toString() == 'err') {
        //SaveUserLogin();
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('UserToken',response.data.toString());
        checkToken(response.data.toString());
      }
    } catch (e) {
      print("ErrorTokenCheck" + e.toString());
    }


  }

  LogOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushNamed('/InputNumber');
  }
}

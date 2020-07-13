import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'InputNumber.dart';
import 'package:dio/dio.dart';
import 'dart:math';
import 'package:progress_dialog/progress_dialog.dart';
class input_number extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return input_numberState();
  }

}

ProgressDialog LoadingPr ;
class input_numberState extends State<input_number> {
  TextEditingController numberController;
  var InputTextField, EnterBitton;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

     LoadingPr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs:false);
    return WillPopScope(child:  Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: new AppBar(title: new Container(),
          backgroundColor: Color(0xff347c2c),
          leading: Padding(padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
              child: Center(
                  child: Text('ورود', style: TextStyle(fontSize: 25))))
      ), body: new Container(
      child: Column(
        children: <Widget>[
          InputTextField,
          Padding(padding: EdgeInsets.symmetric(vertical: 80)),
          new Center(child: EnterBitton)
        ],
      ),
    ),
    ),
        onWillPop: () => Future(() => false));
  }

  @override
  void initState() {

    numberController = new TextEditingController();
    InputTextField = new Container(
        margin: EdgeInsets.all(20.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
          border: new Border.all(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        child:
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Flexible(
                fit: FlexFit.loose,
                child: new Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: new TextField(
                      controller: numberController,
                      textAlign: TextAlign.center,
                      decoration: new InputDecoration(
                        hintText: 'شماره موبایل',
                      ),
                    )
                )),
            new Flexible(fit: FlexFit.loose, child:
            new Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: new Text('98+'))
            )
          ],)
    );

    EnterBitton = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(child: new Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0), child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.green)),
          color: Colors.green,
          textColor: Colors.white,
          padding: EdgeInsets.all(8.0),
          onPressed: GotoNext,
          child: Text(
            "ارسال".toUpperCase(),
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
        ),
        )
        )
      ],
    );
  }

  void GotoNext() {
    _openLoadingDialog(context);
    var rng = new Random();
    CheckNumber('0' + numberController.text,rng.nextInt(9768));
  }

  void SendSms(number, code) async {
    print('CODEEE'+code.toString());
    FormData formData = FormData.fromMap({
      "MessageTxt":'راننده گرامی خوش امدید کد ورود شما : '+ code.toString(),
      "Mobile": number,
    });
    try {
      Response response = await Dio().post("https://sahandtehran.ir:3000/Sms/Sms",data:formData);
      print(response);
      print(response.statusCode);
      String finalText = 'کدفعالسازی به شماره ' + numberController.text + 'ارسال شد.';
      Navigator.push(context, MaterialPageRoute(builder: (context) => new verify_number(finalText,code,numberController.text)));
      print(finalText);
    } catch (e) {
      print(e);
    }
  }
  void _openLoadingDialog(BuildContext context)   {
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
  void CheckNumber(number,code) async {

    FormData formData = FormData.fromMap({
      "Number":number,
    });
    try {
      Response response = await Dio().post("https://sahandtehran.ir:3000/DriverLogin/CheckDriverNumber",data:formData);
      if(response.data.toString() =='DriverExist'){

        SendSms('0' + numberController.text, code);

      }else if(response.data.toString() == 'DriverNotExist'){
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "شماره شما وجود ندارد. لطفا ثبت نام کنید.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.yellow,
            textColor: Colors.black,
            fontSize: 16.0
        );
      }
    } catch (e) {
      print(e);
    }
  }

}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sahanddriver/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class input_Number extends StatefulWidget{
  final String tezxt;
  final  int ConfCode;
  final String UserNumber;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return input_NumberState();
  }
  input_Number(this.tezxt,this.ConfCode,this.UserNumber);

}


class input_NumberState extends State<input_Number> with TickerProviderStateMixin
{
  final myController = TextEditingController();
  var TipText,InputTextField,timerText;
  static TextEditingController numberController;
  static String ConfirmCode;
  static String UserNumber;
  static const int kStartValue = 60;
  AnimationController _controller;

  final Logo=new Image(image: AssetImage('assets/images/logo.png'),fit: BoxFit.contain,width: 150,height: 150);




  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return WillPopScope(child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: new AppBar(title: new Container(),backgroundColor: Color(0xff008860),leading:  Padding(padding: EdgeInsets.fromLTRB(0, 0, 12, 0),child:Center(child:Text('ورود',style: TextStyle(fontSize: 25))))
      ),body: new Container(
      child: Column(
        children: <Widget>[
          Logo,
          TipText,
          InputTextField,
          new Countdown(
            animation: new StepTween(
              begin: kStartValue,
              end: 0,
            ).animate(_controller),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 50)),
          new Center(child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child:  new Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),child:  FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.green)),
                color: Colors.green,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                onPressed: () {
                  _openLoadingDialog(context);
                  print(numberController.text);
                  if(numberController.text == ConfirmCode){
                    //CreateToken(UserNumber,context);
                    addStringToSF(UserNumber,context);
                  }else{
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: "کد وارد شذه اشتباه است.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }

                },
                child: Text(
                  "ورود".toUpperCase(),
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),))
            ],
          ))
        ],
      ),
    ),
    ), onWillPop: () => Future(() => false));

  }

  @override
  void initState() {
    numberController = new TextEditingController();
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: kStartValue),
    );
    _controller.forward(from: 0.0);
    TipText=new Text(widget.tezxt);
    ConfirmCode = widget.ConfCode.toString();
    UserNumber = widget.UserNumber.toString();

    InputTextField=  new Container(
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
                child: new Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5),child: new TextField(
                  controller: numberController,
                  textAlign: TextAlign.center,
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: 'کد فعالسازی را وارد نمایید',
                  ),
                ))),
          ],)
    );

  }
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


void CreateToken(number,context) async {
  FormData formData = FormData.fromMap({
    "UserId":number,
  });
  try {
    Response response = await Dio().post("https://sahandtehran.ir:3000/Token/CreateToken",data:formData);
    print(response.data.toString());
    if(response.data.toString() !='Error:304'){
      print('Create token Response : '+ response.data.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('UserToken', response.data.toString());
      //addStringToSF();
      //SaveUserNumber(number);
      SaveUserNumber(number,context);

    }else{
      Fluttertoast.showToast(
          msg: "مشکلی وجود دارد.لطفا دوباره امتحان کنید.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellowAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  } catch (e) {
    print(e);
  }
}







addStringToSF(UserNumber,Context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('IsLogedIn', "True");
  CreateToken('0'+UserNumber,Context);


}

SaveUserNumber(UserNumber,Context) async {
  print('usernumber : '+UserNumber);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('UserNumber',UserNumber);
  Navigator.of(Context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  HomePage())),(Route<dynamic> route) => false);

}

class Countdown extends AnimatedWidget {
  Countdown({ Key key, this.animation }) : super(key: key, listenable: animation);
  Animation<int> animation;
  @override
  build(BuildContext context){
   if(animation.value == 0){
     return new InkWell(
       child:Text(
         'کد دوباره ارسال شود',
         style: new TextStyle(fontSize: 20.0,color: Colors.blue),
       ),
       onTap: () {

         Navigator.of(context).pushNamed('/InputNumber');
         },
     );

   }else{
     return new Text(
       animation.value.toString(),
       style: new TextStyle(fontSize: 25.0,color: Colors.blue),
     );
   }

  }

}

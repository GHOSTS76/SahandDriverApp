import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profliedriver extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileDriverState();

  }
}
class ProfileDriverState extends State<profliedriver>{
  var DriverName,PhoneNumber,EmailAddress,Picture;
  Future _future;
  bool IsActive;
  var dio;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = GetDriverData();
    dio = Dio()..interceptors.add(RetryInterceptor(
        options: const RetryOptions(
          retries: 2, // Number of retries before a failure
          retryInterval: const Duration(seconds: 10), // Interval between each retry
        )
    ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new FutureBuilder(
      future:_future ,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData ?   Scaffold(
          body: Column(
            children: <Widget>[
              new Align(
                  alignment: Alignment.center,
                  child: Padding(padding: EdgeInsets.only(top: 40),child: new Text(DriverName,style: TextStyle(color: Colors.grey,fontSize: 25),),)
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RatingBar(
                    ignoreGestures: true,
                    itemSize: 20.0,
                    initialRating: 5,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  Container(height: 20, child: VerticalDivider(color: Colors.black)),
                  new Text('0'),
                  Padding(padding: EdgeInsets.only(right: 5),child:new Text('نظر'),)

                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20),child:Divider(color: Colors.grey,thickness: 1,),),
              Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(right: 20,top: 10),child:  new Text('آدرس ایمیل',style: TextStyle(fontSize: 18,color: Colors.grey),),),
                  Container(height: 20, child: VerticalDivider(color: Colors.black)),
                  Padding(padding: EdgeInsets.only(right: 20),child:  new Text(EmailAddress,style: TextStyle(fontSize: 18,color: Colors.grey),),),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10),child:Divider(color: Colors.grey,thickness: 1,),),
              Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(right: 20,top: 10),child:  new Text('شماره تلفن',style: TextStyle(fontSize: 18,color: Colors.grey),),),
                  Container(height: 20, child: VerticalDivider(color: Colors.black)),
                  Padding(padding: EdgeInsets.only(right: 20),child:  new Text(PhoneNumber,style: TextStyle(fontSize: 18,color: Colors.grey),),),
                ],
              ),
              Padding(padding: EdgeInsets.only(top:80),
                  child:
                  Visibility(child:Container(
                    child: Center(
                        child:
                        Padding(padding:EdgeInsets.all(1),child: new Text('اطلاعات شما منتظر تایید میباشد',style: TextStyle(color: Colors.white),),)
                    ),
                    width: 160,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xff9e9e9e),
                      borderRadius: BorderRadius.circular(55),
                    ),
                  ),visible: IsActive,)
              ),
              Padding(padding: EdgeInsets.only(top: 40),child:
              InkWell(
                child: Container(
                  child: Center(
                      child:
                      Padding(padding:EdgeInsets.all(1),child: new Text('خروج',style: TextStyle(color: Colors.white),),)
                  ),
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xff586e89),
                    borderRadius: BorderRadius.circular(60),
                    boxShadow:[BoxShadow(offset: const Offset(0,7), blurRadius: 6,color: const Color(0xff000000).withOpacity(0.16),)],
                  ),

                ) ,
                onTap: (){
                  Alert(
                    context: context,
                    type: AlertType.none,
                    title: "خروج",
                    desc: "آیا میخواید از حساب کاربری خود خارج شوید؟",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "بله",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () =>ExitAccount(),
                        color:Colors.red,
                      ),
                      DialogButton(
                        child: Text(
                          "خیر",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.green,
                      )
                    ],
                  ).show();
                },
              )
              )
            ],
          ),
        ): new Center(child: CircularProgressIndicator(),);
      },
    );


  }
  void TerminateToken(userToken,context) async {
    FormData formData = FormData.fromMap({
      "UserToken":userToken,
    });
    try {
      Response response = await Dio().post("https://sahandtehran.ir:3000/Token/TerminateToken",data:formData);
      if(response.data.toString() !='Error:304'){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Navigator.of(context).pushNamed('/InputNumber');
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

  UpdateTravelStateoff(State) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  var natcode=  prefs.getString('NationalCode');
    print(State);
    FormData formData = FormData.fromMap({
      "DriverID":natcode,
      "State":State,
    });
    try {
      Response response = await dio.post('https://sahandtehran.ir:3000/DriverMain/UpdateDriverReadyToWork',data:formData);
      print('UpdateDriver'+response.toString());
      if(response.toString() =='Updated'){
        TerminateToken(PhoneNumber,context);
      }
    } catch (e) {
      print(e);
    }
  }
  GetDriverData() async   {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Numbr = prefs.getString('UserNumber');
    FormData formData = FormData.fromMap({
      "Number": Numbr,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/GetDriverData", data: formData);
      print(response);
      DriverName = response.data['FName'] + ' '+ response.data['LName'];
      PhoneNumber =response.data['MobileNo'];
      EmailAddress = response.data['Email'];
      IsActive = response.data['IsActive'];
      Picture = response.data['PicURL'];
      if(IsActive == true){
        IsActive = false;
      }
      return true;
    } catch (e) {
      print(e);
    }
  }

  ExitAccount() async {
    UpdateTravelStateoff(0);
  }
}

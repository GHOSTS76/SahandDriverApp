import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sahanddriver/HomePage.dart';
import 'package:sahanddriver/Profile.dart';
import 'package:sahanddriver/TravelHistory.dart';
import 'package:sahanddriver/setting.dart';
import 'package:sahanddriver/startofwork.dart';
import 'package:sahanddriver/wallet.dart';
Drawer BuildDrawerLayout(BuildContext context, var Name,var DriverNumber,var PicrureUrl,var PageName,var NatCode){
  return new Drawer(

    child: new ListView(
      children: <Widget>[
        new DrawerHeader(
          padding : EdgeInsets.zero,
            child:new Container(
              decoration: new BoxDecoration(
                color: Color(0xff0bab2a)
              ),
              child: new Stack(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.bottomCenter,
                    child: new Padding(
                        padding: EdgeInsets.only(bottom: 30),
                      child:RatingBar(
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
                    ),
                  ),
                  new Align(
                    alignment: Alignment.centerRight,
                    child: new ListTile(
                      leading: new CircleAvatar(
                        radius: 30,
                        backgroundImage: CachedNetworkImageProvider(PicrureUrl) ,
                      ),
                      title:Padding(padding: EdgeInsets.only(bottom: 25),child: new Text(Name,style: TextStyle(
                        fontSize: 15, color: Colors.white,
                      ),
                      ),
                      )
                    ),
                  ),
                  new Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(padding: EdgeInsets.only(bottom: 60,left: 45),child: new Text(DriverNumber,style: TextStyle(
                      fontSize: 15, color: Colors.white,
                    ),
                    ),
                    )
                  )
                ],
              ),
            )
        ),
        new ListTile(
          leading:
          ImageIcon(
            AssetImage("assets/images/profileic.png"),
            color: Colors.green,
          ),
          title: new Text('پروفایل',style:TextStyle(
            fontSize: 16,
            color: Colors.black,
          )),
          onTap: (){
          Navigator.pushNamed(context, '/Profile');

          },
        ),
        new ListTile(
          leading:
          ImageIcon(
            AssetImage("assets/images/wallet.png"),
            color: Colors.green,
          ),
          title: new Text('کیف اعتباری',style:TextStyle(
            fontSize: 16,
            color: Colors.black,
          )),
          onTap: (){
            Navigator.pushNamed(context, '/Wallet');
         //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  Wallet())),(Route<dynamic> route) => false);

          },
        ),
        new ListTile(
          leading:
          ImageIcon(
            AssetImage("assets/images/history.png"),
            color: Colors.green,
          ),
          title: new Text('تاریخچه سفرها',style:TextStyle(
            fontSize: 16,
            color: Colors.black,
          )),
          onTap: (){
            Navigator.pushNamed(context, '/TravelHistory');

          },
        ),
        new ListTile(
          leading: ImageIcon(
            AssetImage("assets/images/chart.png"),
            color: Colors.green,
          ),
          title: new Text('نمودار عملکرد',style:TextStyle(
            fontSize: 16,
            color: Colors.black,
          )),
          onTap: (){},
        ),
        new ListTile(
          leading:  ImageIcon(
            AssetImage("assets/images/driveclub.png"),
            color: Colors.green,
          ),
          title: new Text('باشگاه رانندگان',style:TextStyle(
            fontSize: 16,
            color: Colors.black,
          )),
          onTap: (){},
        ),

        new ListTile(
          leading:  ImageIcon(
            AssetImage("assets/images/setting.png"),
            color: Colors.green,
          ),
          title: new Text('تنظیمات',style:TextStyle(
            fontSize: 16,
            color: Colors.black,
          )),
          onTap: (){
            Navigator.pushNamed(context, '/Setting');

          },
        ),

        new ListTile(
          leading:  ImageIcon(
            AssetImage("assets/images/support.png"),
            color: Colors.green,
          ),
          title: new Text('پشتیبانی',style:TextStyle(
            fontSize: 16,
            color: Colors.black,
          )),
          onTap: (){},
        ),
        Padding(padding: EdgeInsets.only(top: 20),
            child:
            new ListTile(
          leading: ImageIcon(
            AssetImage("assets/images/off.png"),
            color: Colors.green,
          ),
          title: new Text(PageName,style:TextStyle(
            fontSize: 16,
            color: Colors.black,
          )),
          onTap: (){
            _openLoadingDialog(context);

            if(PageName == 'پایان کار'){
              StopWorking(context,DriverNumber,NatCode);
            }else{
              StartWorking(context,DriverNumber,NatCode);
            }
          },
        )
        ),
      Padding(padding: EdgeInsets.only(right: 20),child:Divider(color: Colors.grey)),
        Padding(padding: EdgeInsets.only(right: 20),child: new Text('نسخه 2.8.0',style:TextStyle(color: Colors.grey)))
      ],

    ),
  );

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
SetDriverIsOnline(IsOnline,NatCode,context) async {
  var dio = Dio()..interceptors.add(RetryInterceptor(
      options: const RetryOptions(
        retries: 0, // Number of retries before a failure
        retryInterval: const Duration(seconds: 10000), // Interval between each retry
      )
  ));
  FormData formData = FormData.fromMap({
    "Driverid": NatCode,
    "DriverIsOnline":IsOnline,
  });
  try {
    Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/UpdateDriverOnlineState", data: formData);
    if(response.data.toString() == 'Updated'){
    }
    return true;
  } catch (e) {
    print(e);
  }
}
StartWorking(context,DriverNumber,Natcode) async {
  _openLoadingDialog(context);
  FormData formData = FormData.fromMap({
    "State": '1',
    "MobileNo":DriverNumber,
  });
  try {
    Response response = await Dio().post("https://sahandtehran.ir:3000/DriverMain/VecInout", data: formData);
    print(response);
    if(response.data.toString() == 'Done'){
     await SetDriverIsOnline('1',Natcode,context);
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  StartOfWork())),(Route<dynamic> route) => false);

    }
    return true;
  } catch (e) {
    print(e);
  }
}
StopWorking(context,DriverNumber,Natcode) async {
  FormData formData = FormData.fromMap({
    "State": '0',
    "MobileNo":DriverNumber,
  });
  try {
    Response response = await Dio().post("https://sahandtehran.ir:3000/DriverMain/VecInout", data: formData);
    print(response);
    if(response.data.toString() == 'Done'){
     await SetDriverIsOnline('0',Natcode,context);
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  HomePage())),(Route<dynamic> route) => false);
    }
    return true;
  } catch (e) {
    print(e);
  }
}


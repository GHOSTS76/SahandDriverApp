import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sahanddriver/startofwork.dart';
class EndTravel extends StatefulWidget{
  var Tripid;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EndTravelState();
  }
EndTravel(this.Tripid);
}

class EndTravelState extends State<EndTravel>{
  var Rate,dio;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio = Dio()..interceptors.add(RetryInterceptor(
        options: const RetryOptions(
          retries: 0, // Number of retries before a failure
          retryInterval: const Duration(seconds: 1000), // Interval between each retry
        )
    ));
    TripID = widget.Tripid.toString();
  }
 var TripID;
  final appbar = new AppBar(
    iconTheme: IconThemeData(color:Color(0xff008860)),
    backgroundColor: Colors.white,
    title: ListTile(
      leading: ListTile(
        leading:
        ImageIcon(
          AssetImage("assets/images/profileic.png"),
          color: Colors.green,
        ),
        title: new Text('لطفا به مسافر خود امتیاز دهید.',style:TextStyle(
          fontSize: 16,
          color: Colors.black,
        )),
      ),
    ) ,
    elevation: 0,
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      appBar: appbar,
      body:
      Column(
        children: <Widget>[
          Container(
            color: Color(0xff008860),
            height: 280,
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 18),child: new Text('هزینه دریافتی از مسافر',style: TextStyle(
                      color: Colors.white,
                      fontSize: 24
                  ),),),
                  Padding(padding: EdgeInsets.only(top: 20),child:const Text(
                    '0 ریال ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'IRANSans',
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Color(0xffffb421),
                    ),
                  )
                  ),
                  Padding(padding: EdgeInsets.only(top: 10),child:     Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),),
                  Padding(padding: EdgeInsets.only(top: 10),child:  Text(
                    'هزینه سفر',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'B Koodak',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),),
                  Padding(padding: EdgeInsets.only(top: 15),child:  Text(
                    '0 ریال',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'IRANSans',
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: Color(0xffffffff),
                    ),
                  ),)
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: 60,
            child: Center(
              child:  Text(
                'با تشکر از شما، راننده محترم',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'IRANSans',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff008860),
                ),
              ),
            ),
          ),
          Container(
            color:  Color(0xfff0f0f0),
            height: 100,
            child: Column(
              children: <Widget>[
                Center(
                  child: Padding(padding: EdgeInsets.only(top: 5),child:  Text(
                    'لطفا رضایت خود از مسافر را اعلام نمایید',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'IRANSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff8e8c8c),
                    ),
                  ),),

                ),
                Center(
                  child: RatingBar(
                    ignoreGestures: false,
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
                      Rate= rating;
                    },
                  ),
                ),
                Center(
                  child:Padding(padding: EdgeInsets.only(top: 10),child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 20,
                        height: 2,
                        color: const Color(0xffb4b4b4),
                      ),
                      Padding(padding: EdgeInsets.only(left: 5,right: 5),child: new Text('عالی',style: TextStyle(color: Colors.black45,fontSize: 16),),),
                      Container(
                        width: 20,
                        height: 2,
                        color: const Color(0xffb4b4b4),
                      ),
                    ],
                  ),)
                ),

              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Color(0xffb4b4b4),
          ),
          Expanded(child:
          new Align
            (
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              color:  Color(0xff008860),
              child:Center(
                child:InkWell(child:new Text(
      'تایید',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'IRANSans',
        fontSize: 26,
        fontWeight: FontWeight.w500,
        color: Color(0xffffffff),
      ),
    ),
                  onTap:(){
                    _SubmitScore();
                  },
                )
              ),
            ) ,
          ))
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

  Future<void> _SubmitScore() async {
    _openLoadingDialog(context);
    FormData formData = FormData.fromMap({
      "id":TripID,
      "DriverComment":',',
      "PassengerScore":Rate.toString(),
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/Comments/DriverComment",data:formData);
      if(response.data.toString() =='CommentSumbitted'){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  StartOfWork())),(Route<dynamic> route) => false);

      }else{
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "اشکال در ثبت امتیاز",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black45,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    } catch (e) {
      print("ErrorTokenCheck"+e);
    }
  }
}
import 'dart:convert';
import 'package:dio_retry/dio_retry.dart';
import 'package:jalali_date/jalali_date.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sahanddriver/TravelHistotyDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TravelHistory extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TravelHistoryState();
  }
  
}

class TravelHistoryState extends State<TravelHistory>{
  Future _future;
  List data;
  var Hasdataa;
  var StartAddres,EndAddress,StartTime;
  var dio;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future=GetItems();
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
    return FutureBuilder(
      future:_future ,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var appscaffold;
        print('SnapShotHasData');
        print('data Datas='+data.toString());
      if(snapshot.hasData){
        if(Hasdataa == 'No'){
          appscaffold = Scaffold(
            appBar:  new AppBar(
              bottom: PreferredSize(child: Column(children: <Widget>[    Container(
                height: 100,
                color:Color(0xff008860),
                child: Padding(padding: EdgeInsets.only(top: 20),
                  child:
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Text('0',style: TextStyle(color: Color(0xffffb421),fontSize: 20),),
                          // Container(height: 40, child: VerticalDivider(color: Colors.grey)),
                          new Text('0'+'   '+'ریال',style: TextStyle(color: Color(0xffffb421),fontSize: 20),),
                          //    Container(height: 40, child: VerticalDivider(color: Color(0xffb4b4b4))),
                          new Text('1',style: TextStyle(color: Color(0xffffb421),fontSize: 20),)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Text('تمامی سفرها',style: TextStyle(color: Colors.white,fontSize: 18),),
                          new Text('درآمد امروز',style: TextStyle(color: Colors.white,fontSize: 18),),
                          new Text('سفرهای امروز',style: TextStyle(color: Colors.white,fontSize: 18),)
                        ],
                      )
                    ],
                  ),),
              ),
                Container(
                  height: 50,
                  color: const Color(0xfffafafa),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(right: 20),child: new Text('سفرهای امروز',style: TextStyle(color: Colors.black45,fontSize: 16),),),
                      Padding(padding: EdgeInsets.only(left: 20),child:  new Text('0',style: TextStyle(color: Colors.black45,fontSize: 16),) ,),
                    ],
                  ),
                ),],), preferredSize: Size.fromHeight(150.0)),
              elevation:0,
              title: new Text('تاریخچه سفرها',style: TextStyle(color: Colors.white,fontSize: 20),),
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor:  Color(0xff008860),
            ),
            body:Center(child: new Text('داده ای وجود ندارد!',style: TextStyle(color: Colors.green,fontSize: 20,fontFamily: 'IRANSans'),),),
          );
        }else
        {
          appscaffold = Scaffold(
              backgroundColor: Color(0xffeeeeee),
              appBar:  new AppBar(
                bottom: PreferredSize(child: Column(children: <Widget>[    Container(
                  height: 100,
                  color:Color(0xff008860),
                  child: Padding(padding: EdgeInsets.only(top: 20),
                    child:
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Text(data.length.toString(),style: TextStyle(color: Color(0xffffb421),fontSize: 20),),
                            // Container(height: 40, child: VerticalDivider(color: Colors.grey)),
                            new Text('0'+'   '+'ریال',style: TextStyle(color: Color(0xffffb421),fontSize: 20),),
                            //    Container(height: 40, child: VerticalDivider(color: Color(0xffb4b4b4))),
                            new Text('1',style: TextStyle(color: Color(0xffffb421),fontSize: 20),)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Text('تمامی سفرها',style: TextStyle(color: Colors.white,fontSize: 18),),
                            new Text('درآمد امروز',style: TextStyle(color: Colors.white,fontSize: 18),),
                            new Text('سفرهای امروز',style: TextStyle(color: Colors.white,fontSize: 18),)
                          ],
                        )
                      ],
                    ),),
                ),
                  Container(
                    height: 50,
                    color: const Color(0xfffafafa),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(right: 20),child: new Text('سفرهای امروز',style: TextStyle(color: Colors.black45,fontSize: 16),),),
                        Padding(padding: EdgeInsets.only(left: 20),child:  new Text(PersianDate.fromGregorianString(Convertdate(StartTime)).toString(),style: TextStyle(color: Colors.black45,fontSize: 16),) ,),
                      ],
                    ),
                  ),],), preferredSize: Size.fromHeight(150.0)),
                elevation:0,
                title: new Text('تاریخچه سفرها',style: TextStyle(color: Colors.white,fontSize: 20),),
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor:  Color(0xff008860),
              ),
              body: new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context,int index){
                    return  new Card(
                      child: InkWell(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.only(right: 10),child:  new Text('کد سفر'+'  '+data[index]["id"],style: TextStyle(color: Colors.black45,fontSize: 16),),),
                                      Padding(padding: EdgeInsets.only(left: 10),child: new Text(PersianDate.fromGregorianString(data[index]["created_ts"]).toString(),style: TextStyle(color: Colors.black45,fontSize: 16) ,),)
                                    ],
                                  ),
                                  height: 40,
                                  color: const Color(0xffeeeeee),
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(padding:EdgeInsets.only(top: 10,right: 10),child:   Image.asset('assets/images/mabda.png',height: 20,width: 20,),),
                                    Padding(padding: EdgeInsets.only(top: 10,right: 10),child: new Text('مبدا',style: TextStyle(color: Colors.black,fontSize: 20),),),
                                    Container(height: 20, child: VerticalDivider(color: Colors.grey)),
                                    new Flexible(child:  Padding(
                                        padding: EdgeInsets.only(right: 10,top: 10),
                                        child:
                                        Text(
                                          data[index]["StartAddress"],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'IRANSans'),
                                        )
                                    )),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(padding:EdgeInsets.only(top: 10,right: 10),child:   Image.asset('assets/images/maghsad.png',height: 20,width: 20,),),
                                    Padding(padding: EdgeInsets.only(top: 10,right: 10),child: new Text('مقصد',style: TextStyle(color: Colors.black,fontSize: 20),),),
                                    Container(height: 20, child: VerticalDivider(color: Colors.grey)),
                                    new Flexible(child:  Padding(
                                        padding: EdgeInsets.only(right: 10,top: 10),
                                        child:
                                        Text(
                                          data[index]["EndAddress"],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'IRANSans'),
                                        )


                                    ))
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(padding:EdgeInsets.only(top: 10,right: 10),child:   Image.asset('assets/images/time.png',height: 20,width: 20,),),
                                    Padding(padding: EdgeInsets.only(top: 10,right: 10),child: new Text('توقف',style: TextStyle(color: Colors.black,fontSize: 20),),),
                                    Container(height: 20, child: VerticalDivider(color: Colors.grey)),
                                    Padding(padding: EdgeInsets.only(top: 10,right: 10),child: new Text('بدون توقف',style: TextStyle(color: Colors.black45,fontSize: 18),),)
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(padding:EdgeInsets.only(top: 10,right: 10),child:   Image.asset('assets/images/card.png',height: 20,width: 20,),),
                                    Padding(padding: EdgeInsets.only(top: 10,right: 10),child: new Text('مبلغ',style: TextStyle(color: Colors.black,fontSize: 20),),),
                                    Container(height: 20, child: VerticalDivider(color: Colors.grey)),
                                    Padding(padding: EdgeInsets.only(top: 10,right: 10),child: new Text(data[index]["total_price"]+'  '+'ریال',style: TextStyle(color: Colors.black45,fontSize: 18),),)
                                  ],
                                ),
                              ],
                            ),
                            height: 270,
                            color: Colors.white,
                          ),
                          onTap: () {
                            GotoDetails(data[index]["id"]);
                          }
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.all(10),
                      elevation: 5,
                      color: Colors.white,

                    );
                  }
              )
          );
        }
      }
        return snapshot.hasData ? Scaffold(
            body: appscaffold
        ) : new Center(child: CircularProgressIndicator(),);
      },
    );
  }

  Convertdate(String Date){
   var DateArray =  Date.split('-');

   var DateForConvert = DateArray[0]+'0'+DateArray[1]+'0'+DateArray[2];

   return DateForConvert;
  }

  GetItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   String NatCode = prefs.getString('NationalCode');
   print('NatCode'+NatCode);
    FormData formData = FormData.fromMap({
      "DriverID": NatCode,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/Ride/GetDriverRides", data: formData);
      print(response);
      if(response.data.toString() == 'notFound'){
        Hasdataa = 'No';
        return false;
      }else{
        data = jsonDecode(response.data);
        bool gettime = await GetDateTime();
        print('RRRRRR');
        print(data);
        return data;
      }
    } catch (e) {
      print(e);
    }
  }

  WrapText(Text){
    int TextLong;
    TextLong = Text.toString().length;
    if(TextLong >= 40)
    {
      var bendedText = Text.toString().substring(0,45) +'\n'+ Text.toString().substring(45,TextLong);
      return bendedText;
    }
  }

  GotoDetails(TripId){
    Navigator.push(context, MaterialPageRoute(builder: (context) => new Directionality(textDirection: TextDirection.rtl, child:TravelDetails(TripId))));
  }
  GetDateTime() async {
    FormData formData = FormData.fromMap({
      "RequestType": 'Date',
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/GetDateTime", data: formData);
      print('TimeResponse'+response.data.toString());
      StartTime = response.data.toString();
      return true;
    } catch (e) {
      print(e);
    }
  }
}


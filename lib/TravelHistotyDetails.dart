import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:jalali_date/jalali_date.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TravelDetails extends StatefulWidget{
  var Tripid;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TravelDetailsState();
  }
  TravelDetails(this.Tripid);

}

class TravelDetailsState extends State<TravelDetails>{
  Future _future;
  static var TripIdd;
  var Desteniton,Origin,Stop,Date,Time,price;
  var Token;
  var destLocation,OriginLocation;
  var OriginLat,OriginLong,destLat,destLong;
  var dio;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = GetTripData();
    dio = Dio()..interceptors.add(RetryInterceptor(
        options: const RetryOptions(
          retries: 2, // Number of retries before a failure
          retryInterval: const Duration(seconds: 10), // Interval between each retry
        )
    ));
    TripIdd = widget.Tripid.toString();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData ? Scaffold(
            body:  Scaffold(
              backgroundColor: Color(0xffeeeeee),
              appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.white),
                  backgroundColor:  Color(0xff008860),
                  elevation: 9.0,
                  title: Row(children: <Widget>[
                    new Text('کد سفر',style: TextStyle(fontSize: 20,color: Colors.white),),
                    Padding(padding: EdgeInsets.only(right: 10),child:   new Text(TripIdd,style: TextStyle(fontSize: 20,color: Colors.white),),)
                  ],)
              ),
              body: Column(
                children: <Widget>[
                  Container(
                    height: 90,
                    color:Colors.white,
                    child:Column(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children:
                          <Widget>[
                            Padding(padding: EdgeInsets.only(right: 10),child: Text(
                              'اعتباری',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'IRANSans',
                                fontSize: 18,
                                color: Color(0xff262626),
                              ),
                            ),),
                            Padding(padding: EdgeInsets.only(top: 10),child:
                            Container(
                              width: 3,
                              height: 80,
                              color: const Color(0xffb4b4b4),
                            ),),
                            Text(
                              'مبلغ پرداختی\nهزینه سفر',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'IRANSans',
                                fontSize: 18,
                                color: Color(0xff8e8c8c),
                              ),
                            ),
                            Column(children:<Widget>[
                              Text(
                                '0',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'IRANSans',
                                  fontSize: 18,
                                  color: Color(0xff0a4276),
                                ),
                              ),
                              Text(
                                '0',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'IRANSans',
                                  fontSize: 18,
                                  color: Color(0xff262626),
                                ),
                              )
                            ],
                            ),
                            Column(children:<Widget>[
                              Text(
                                'ریال',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'IRANSans',
                                  fontSize: 18,
                                  color: Color(0xff0a4276),
                                ),
                              ),
                              Text(
                                'ریال',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'IRANSans',
                                  fontSize: 18,
                                  color: Color(0xff262626),
                                ),
                              )
                            ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 10),child: Container(
                              width: 3,
                              height: 80,
                              color: const Color(0xffb4b4b4),
                            )),
                            Padding(padding: EdgeInsets.only(left: 10),child: Text(
                              PersianDate.fromGregorianString(Date).toString()+'\n'+Time,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'IRANSans',
                                fontSize: 18,
                                color: Color(0xff262626),
                              ),
                            )),

                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: 180,
                        child:   FlutterMap(
                          options: new MapOptions(
                            center: new LatLng(double.parse(OriginLat),double.parse(destLong)),
                            zoom: 13.0,
                          ),
                          layers: [
                            new TileLayerOptions(
                                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                additionalOptions: {
                                  'accessToken': '<PUT_ACCESS_TOKEN_HERE>',
                                  'id': 'mapbox.streets',
                                },
                                subdomains: ['a', 'b', 'c']
                            ),
                            new MarkerLayerOptions(
                              markers: [
                                new Marker(
                                    width: 60,
                                    height: 60,
                                    point: new LatLng(double.parse(OriginLat),double.parse(OriginLong)),
                                    builder: (context) {
                                      return new Container(
                                        child: Image.asset('assets/images/mabda_ic.png'),
                                      );
                                    }
                                ),
                                new Marker(
                                    width: 60,
                                    height: 60,
                                    point: new LatLng(double.parse(destLat),double.parse(destLong)),
                                    builder: (context) {
                                      return new Container(
                                        child: Image.asset('assets/images/maghsad_ic.png'),
                                      );
                                    }
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(padding:EdgeInsets.only(top: 10,right: 10),child:   Image.asset('assets/images/mabda.png',height: 20,width: 20,),),
                                Padding(padding: EdgeInsets.only(top: 10,right: 10),child: new Text('مبدا',style: TextStyle(color: Colors.black,fontSize: 20),),),
                                Container(height: 20, child: VerticalDivider(color: Colors.grey)),
                                new Flexible(child:  Padding(
                                    padding: EdgeInsets.only(right: 10,top: 10),
                                    child:
                                    Text(
                                      Origin,
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
                                Padding(padding:EdgeInsets.only(top: 10,right: 10),child:   Image.asset('assets/images/maghsad.png',height: 20,width: 20,),),
                                Padding(padding: EdgeInsets.only(top: 10,right: 10),child: new Text('مقصد',style: TextStyle(color: Colors.black,fontSize: 20),),),
                                Container(height: 20, child: VerticalDivider(color: Colors.grey)),
                                new Flexible(child:  Padding(
                                    padding: EdgeInsets.only(right: 10,top: 10),
                                    child:
                                    Text(
                                      Desteniton,
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
                                Padding(padding: EdgeInsets.only(top: 10,right: 10),child: new Text(price+'  '+'ریال',style: TextStyle(color: Colors.black45,fontSize: 18),),)
                              ],
                            ),
                          ],
                        ),
                        height: 200,
                        color: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            ),
        ) : new Center(child: CircularProgressIndicator(),);
      },
    );


  }
  GetTripData() async {
    print('Here');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Token = prefs.getString('UserToken');
    FormData formData = FormData.fromMap({
      "id": TripIdd,
      "UserTokenCheck": Token,
    });
    try {
      print('Intry');
      Response response = await dio.post("https://sahandtehran.ir:3000/Ride/GetRide", data: formData);
      Map<String, dynamic> user  = jsonDecode(response.data);
      print(jsonDecode(response.data).toString());
      Desteniton =   user['StartAddress'];
      Origin = user['EndAddress'];
      Date =  user['created_ts'];
      print('DFDFDF'+user['end_ts']);
      Time = user['end_ts'];
      price = user['total_price'];
      destLocation = user['start_lat_lng'];
      var DesArray = destLocation.toString().split(',');
      print('DestenArray'+DesArray.toString());
      destLat = DesArray[0];
      destLong = DesArray[1];
      OriginLocation = user['end_lat_lng'];
      var OriginArray = OriginLocation.toString().split(',');
      print('OriginArray'+OriginArray.toString());
      OriginLat = OriginArray[0];
      OriginLong = OriginArray[1];
      return true;
    } catch (e) {
      print(e);
    }
  }
}
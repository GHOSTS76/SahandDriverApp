import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:sahanddriver/MainRequestAccept.dart';
import 'package:sahanddriver/startofwork.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:wakelock/wakelock.dart';
class TravelRequest extends StatefulWidget{
   var TripData;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TravelRequestState();
  }
  TravelRequest(this.TripData);
}
class TravelRequestState extends State<TravelRequest>  with TickerProviderStateMixin{
  Socket socket;
  var datas;
  String Numbr;
  final myController = TextEditingController();
  static const int kStartValue = 30;
  AnimationController _controller;
  var StartLocationArray,EndLocationArray;
  var StartAddres,EndAddress,dio;
  String TripId;
  int s = 0;
  var EndPoint,StartPoint,SecondLocation,SecondLoc,backforth,PassengerID;
  AudioCache _audioCache;
  bool SoundState= true;
  var NatCode;
  Timer timer;
  Map<String, dynamic> tripMap = new Map();
  @override
  void initState() {
    super.initState();
    int TimerSecs = 30;
    timer = Timer.periodic(Duration(seconds:TimerSecs), (Timer t) =>DeclineTravel());
   _ConnectSocket();
    _ListenToDriverAccept2();
    dio = Dio()..interceptors.add(RetryInterceptor(
        options: const RetryOptions(
          retries: 0, // Number of retries before a failure
          retryInterval: const Duration(seconds: 10000), // Interval between each retry
        )
    ));
    Wakelock.enable();
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: kStartValue),
    );
    _controller.forward(from: 0.0);
    _audioCache = AudioCache(prefix: "audio/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
    //SetDriverIsOnline('1');
  }
  @override
  void dispose() {
    timer.cancel();
    socket.clearListeners();
   // SetDriverIsOnline('0');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new StreamBuilder(
        stream: GetDataFrom().asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData? new Scaffold(
            body:Column(
              children: <Widget>[
                DottedBorder(
                  color: Colors.green,
                  strokeCap: StrokeCap.butt,
                  strokeWidth: 1,
                  child: Container(
                    height: 120,
                    color:Colors.white,
                    child:Column(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children:
                          <Widget>[
                            Padding(padding: EdgeInsets.only(top: 10,right: 10),child:  Column(children:<Widget>[
                              Text(
                                'قیمت سفر:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'IRANSans',
                                  fontSize: 18,
                                  color: Color(0xff0a4276),
                                ),
                              ),
                              Text(
                                'تا مبدا:',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'IRANSans',
                                  fontSize: 18,
                                  color: Color(0xff262626),
                                ),
                              ),
                              Text(
                                'مدت توقف:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'IRANSans',
                                  fontSize: 18,
                                  color: Color(0xff262626),
                                ),
                              )
                            ],
                            ),),
                            Padding(padding: EdgeInsets.only(top: 10),child: Column(children:<Widget>[
                              Text(
                                '0 ریال',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'IRANSans',
                                  fontSize: 18,
                                  color: Color(0xff0a4276),
                                ),
                              ),
                              Text(
                                '0 دقیقه',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'IRANSans',
                                  fontSize: 18,
                                  color: Color(0xff262626),
                                ),
                              ),
                              Text(
                                  'بدون توقف',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'IRANSans',
                                    fontSize: 18,
                                    color: Color(0xff262626),
                                  ),
                                ),
                            ],
                            ),),
                            Padding(padding: EdgeInsets.only(left: 10),child:InkWell(
                              child:  Stack(
                                children: <Widget>[
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff008860),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 3,right: 3),child:
                                  Container(
                                    width: 79,
                                    height: 79,
                                    child: Center(
                                        child: Column(
                                          children: <Widget>[
                                            new Countdown(
                                              animation: new StepTween(
                                                begin: kStartValue,
                                                end: 0,
                                              ).animate(_controller),
                                            ),
                                            InkWell(
                                              child: IgnorePointer(
                                                child: new Text('تایید',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'IranSans'),),
                                              ) ,

                                            )
                                          ],
                                        )
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 3,color: const Color(0xffffffff),),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  ),
                                  Container(
                                    width: 85,
                                    height: 85,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 4,color: const Color(0xff5c5858),),
                                      shape: BoxShape.circle,
                                    ), )
                                ],
                              ),
                              onTap: (){
                                AcceptTravel();
                              },
                            )
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                DottedBorder(
                  color: Colors.green,
                  strokeCap: StrokeCap.butt,
                  strokeWidth: 1,
                  child: Container(
                    height: 50,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/images/maghsad.png'),
                        Padding(padding: EdgeInsets.only(right: 10),child: new Text('مبدا : ',style: TextStyle(color: Colors.black,fontSize: 18),),),
                        new Flexible(child:  Padding(
                            padding: EdgeInsets.only(right: 10),
                            child:
                            Text(
                              StartAddres,
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
                  ),
                ),
                DottedBorder(
                  color: Colors.green,
                  strokeCap: StrokeCap.butt,
                  strokeWidth: 1,
                  child: Container(
                    height: 50,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/images/mabda.png'),
                        Padding(padding: EdgeInsets.only(right: 10),child: new Text('مقصد : ',style: TextStyle(color: Colors.black,fontSize: 18),),),
                        new Flexible(child:  Padding(
                            padding: EdgeInsets.only(right: 10),
                            child:
                            Text(
                              EndAddress,
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
                  ),
                ),
                Container(
                  height: 300,
                  child:   FlutterMap(
                    options: new MapOptions(
                      center: new LatLng( double.parse(StartLocationArray[0]),double.parse(StartLocationArray[1])),
                      zoom: 18.0,
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
                              width: 25,
                              height: 25,
                              point: new LatLng( double.parse(StartLocationArray[0]),double.parse(StartLocationArray[1])),
                              builder: (context) {
                                return new Container(
                                  child: Image.asset('assets/images/mabda_ic.png'),
                                );
                              }
                          ),
                          new Marker(
                              width: 25,
                              height: 25,
                              point: new LatLng(double.parse(EndLocationArray[0]),double.parse(EndLocationArray[1])),
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
              ],
            ),
              appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black), onPressed: () => DeclineTravel()), iconTheme: IconThemeData(color: Colors.black), backgroundColor: Color(0xfff9f9f9), title:new Align(alignment: Alignment.topLeft, child: new Text('راننده سهند',style: TextStyle(fontSize: 20,color: Colors.black),),))
          ):new Center(child: CircularProgressIndicator(),) ;
        },),
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
  _ConnectSocket() async {
    socket = io('https://sahandtehran.ir:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, // optional
    });
    if(!socket.connected)
      {
        socket.connect();
      }
    socket.on('connect', (_) {
        socket.emit('SubmitId',NatCode);
    });

  }
  SetDriverIsOnline(IsOnline) async {
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
  _ListenToDriverAccept2()  {
    socket.on('TripAcceptedDriver', (data) =>
        GotoNext(data)
    );
  }
  DeclineTravel(){
    timer.cancel();
    _openLoadingDialog(context);
    Map<String, dynamic> DeclineMap = new Map();
    DeclineMap['rideId'] = TripId;
      DeclineMap['driverId'] = NatCode;
    socket.emit('DriverDeclineTrip',jsonEncode(DeclineMap));
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  StartOfWork())),(Route<dynamic> route) => true);
  }

  CreateJson() async {
  var DriverPos =  await GetLocation();
  print('AAA'+DriverPos);
    if(SecondLocation == 'null'){
      SecondLoc = '0.00,0.00';
    }else{
      SecondLoc = SecondLocation;
    }
    tripMap['DriverId'] = NatCode;
    tripMap['DriverPos'] = DriverPos;
    tripMap['TripID'] = TripId;
    tripMap['UserId'] = PassengerID;
    socket.emit('TripAccepted', [jsonEncode(tripMap)]);
  }
  void AcceptTravel() async {
    _openLoadingDialog(context);
    timer.cancel();
    CreateJson();
  }
  Future<Stream> GetDataFrom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SoundState = prefs.getBool('GuideSound');
    if(SoundState == null || SoundState =='null'){
      SoundState = true;
    }
     NatCode = prefs.getString('NationalCode');
     Numbr = prefs.getString('UserNumber');
    datas = widget.TripData;
    Map<String, dynamic> user  = jsonDecode(datas);
    PassengerID = user['passenger_id'];
    StartPoint = user['start_lat_lng'];
    SecondLocation = user['extra_destinations'];
    backforth = user['BackAndForth'];
    TripId = user['id'];
    StartAddres = user['StartAddress'];
    EndAddress = user['EndAddress'];
    EndPoint = user['dest_lat_lng'];
    String Start,End;
    Start = StartPoint;
    End = EndPoint;
    StartLocationArray =  Start.split(',');
    EndLocationArray =  End.split(',');
   try{
     if(SoundState){
       if(s==0){
         _audioCache.play('newride.mp3');
         s++;
       }else{
       }
     }
   }catch(ex){
   }
    return Stream.value(true);
  }
  GotoNext(Data) async {
    if(SoundState) {
      _audioCache.play('ride_accepted.mp3');
    }
    socket.clearListeners();
      Navigator.push(context, MaterialPageRoute(builder: (context) => new Directionality(textDirection: TextDirection.rtl, child:  MainRequestAccept(StartAddres,EndAddress,StartPoint,EndPoint,TripId,SecondLocation,backforth.toString(),PassengerID,'0','من رسیدم'))));
  }

}

Future GetLocation() async {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  _locationData = await location.getLocation();
  return _locationData.latitude.toString() + ',' + _locationData.longitude.toString();
}
class Countdown extends AnimatedWidget {
  Countdown({ Key key, this.animation }) : super(key: key, listenable: animation);
  Animation<int> animation;
  @override
  build(BuildContext context){
    if(animation.value == 0){

      return new Text('.',style:TextStyle(color: Colors.green),);

    }else{
      return new Text(
        animation.value.toString(),
        style: new TextStyle(fontSize: 18.0,color: Colors.white),
      );
    }

  }


}

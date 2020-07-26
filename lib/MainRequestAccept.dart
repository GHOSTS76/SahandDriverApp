import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sahanddriver/EndTravel.dart';
import 'package:sahanddriver/startofwork.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';
class MainRequestAccept extends StatefulWidget{
  final String Origin,Destination,TripId,SecLoc,BackandForth,PassengerID,Stage,DownBtnText;
  final  OriginLoc,DestinationLoc;

  @override
  State<StatefulWidget> createState() {

    // TODO: implement createState
    return MainRequestAcceptState();
  }
  MainRequestAccept(this.Destination,this.Origin,this.DestinationLoc,this.OriginLoc,this.TripId,this.SecLoc,this.BackandForth,this.PassengerID,this.Stage,this.DownBtnText);
}
class MainRequestAcceptState extends State<MainRequestAccept>{
  Location location = new Location();
  var UpdateDriverLat,UpdateDriverLong;
  Future _future;
  var IsTravelFinished = false;
  bool SoundState = true;
  String OriginStr='def',DestinationStr='def',StartPoint,EndPoint,StartLat,StartLong,EndLat,EndLong,DownBtn='def',SecondLocation,BackAndForthStr;
  static String TripIdStr;
  int Arrival = 0;
  static bool CancelVisivle = true;
  var StartLocationArray,EndLocationArray;
  var Passengerid,PassengerNameFam,NatCode;
  Timer timer;
  var dio;
  static Socket socket;
  AudioCache _audioCache;
  Map<String, dynamic> PassengerPickUp = new Map();
  Map<String, dynamic> DiverArrivedMap = new Map();
  Map<String, dynamic> EndTravelMap = new Map();
  Map<String, dynamic> ArriveTofirstmap = new Map();
  Map<String, dynamic> CancelTripMap = new Map();
  @override
  Future<void> initState()  {
    // TODO: implement initState
    super.initState();
    _future = getdata();
    dio = Dio()..interceptors.add(RetryInterceptor(
        options: const RetryOptions(
          retries: 0, // Number of retries before a failure
          retryInterval: const Duration(seconds: 1000), // Interval between each retry
        )
    ));
    firsttimeCalled();
    Wakelock.enable();
    _audioCache = AudioCache(prefix: "audio/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) =>GetLocationForUpdate());
  }
  @override
  void dispose() {
    timer?.cancel();
    socket.clearListeners();
   // SetDriverIsOnline('0');
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    final Appbar = AppBar(
      iconTheme: IconThemeData(color: Colors.green),
      backgroundColor:  Color(0xffffffff),
      elevation: 9.0,
      actions: <Widget>[
       Padding(padding:EdgeInsets.only(left: 10),child:  Center(child: InkWell(
         child:Visibility(child:   new Text('لغو سفر',style: TextStyle(fontSize: 18,color:Colors.green),textAlign: TextAlign.center,),visible: CancelVisivle,),
         onTap: (){
           CancelRequest(context);
         },
       ),),)
      ],
      leading:Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 5,right: 0),child:InkWell(child: Image.asset('assets/images/mapicon.png',height: 30,width: 30,),onTap: (){NavigationStart(Arrival);},)),
          Image.asset('assets/images/headsetman.png',height: 25,width: 20,),
          Padding(padding: EdgeInsets.only(right: 0),child: new Text('',style: TextStyle(
              fontSize: 10,
              color: Colors.black
          ),),),
        ],
      ),
    );
    // TODO: implement build
    return WillPopScope(
        child:new FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData? new  Scaffold(
            backgroundColor: Color(0xffeeeeee),
            appBar:  Appbar,
            body:Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 30),child:Padding(padding: EdgeInsets.only(right: 10),child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 20),child: new Text(PassengerNameFam,style: TextStyle(fontSize: 22),),),
                    Padding(padding:EdgeInsets.only(left: 20),child:  Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 20),child:InkWell(child: Icon(Icons.sms,color: Colors.green,size: 30,),onTap:(){  launch('sms://'+Passengerid);},)),

                       InkWell(
                         child:  Icon(Icons.call,color: Colors.green,size: 30,),
                         onTap:(){
                           launch('tel://'+Passengerid);

                         },
                       )
                      ],
                    ) ,)

                  ],
                ),) ,),
                Padding(padding: EdgeInsets.only(top: 40),child: Container(
                    height: 120,
                    color: const Color(0xffffffff),
                    child: Column(
                      children: <Widget>[
                        DottedBorder(
                            color: Colors.green,
                            strokeCap: StrokeCap.butt,
                            strokeWidth: 1,
                            child: Padding(padding: EdgeInsets.only(right: 10),child:
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(right: 1),child:Image.asset('assets/images/maghsad.png',height: 40,width: 40,),),
                                  Padding(padding: EdgeInsets.only(right: 10),child: new Text('مبدا : ',style: TextStyle(color: Colors.black,fontSize: 14),),),
                                  new Flexible(child:  Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child:
                                      Text(
                                        OriginStr,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Colors.black45,
                                            fontSize: 14,
                                            fontFamily: 'IRANSans'),
                                      )
                                  ))
                                ],

                              ),
                            ),)
                        ),
                        DottedBorder(
                          color: Colors.green,
                          strokeCap: StrokeCap.butt,
                          strokeWidth: 1,
                          child: Container(
                            height: 60,
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(right: 1),child: Image.asset('assets/images/mabda.png',height: 40,width: 40,),) ,
                                Padding(padding: EdgeInsets.only(right: 10),child: new Text('مقصد : ',style: TextStyle(color: Colors.black,fontSize: 14),),),
                                new Flexible(child:  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child:
                                    Text(
                                      DestinationStr,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 14,
                                          fontFamily: 'IRANSans'),
                                    )
                                ))
                              ],

                            ),
                          ),
                        ),
                      ],
                    )
                ),),
                Expanded(child: Container(
                  child:FlutterMap(
                    options: new MapOptions(
                      center: new LatLng(double.parse(StartLat),double.parse(EndLong)),
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
                            width: 80.0,
                            height: 80.0,
                            point:new LatLng(double.parse(StartLat),double.parse(StartLong)),
                            builder: (ctx) =>
                            new Container(
                              child: Image.asset('assets/images/mabda_ic.png'),
                            ),
                          ),
                          new Marker(
                            width: 80.0,
                            height: 80.0,
                            point:new LatLng(double.parse(EndLat),double.parse(EndLong)),
                            builder: (ctx) =>
                            new Container(
                              child: Image.asset('assets/images/maghsad_ic.png'),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                ),
                new Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: Container(
                        height: 60,
                        color:  Color(0xff008860),
                        child: Center(
                          child: new Text(DownBtn,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'IRANSans',fontSize: 22,fontWeight: FontWeight.w500,color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                      onTap: (){
                        if(Arrival == 0){
                          DriverArrived();
                        }else if(Arrival == 1){
                          PassengerPickup();
                        }else if(Arrival == 2){
                          EndTravelF();
                        }else if(Arrival ==3){
                          ArriveTofirst();
                        }else if(Arrival == 4){
                          BackAndForth();
                        }
                      },
                    )
                )
              ],
            )
        ):new Center(child: CircularProgressIndicator(),) ;
      },),

        onWillPop: () => Future(() => false));
  }

  TravelDetailes() async {
     UpdateReadyTowork();
     UpdateInTravelState();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      SoundState = prefs.getBool('GuideSound');
      if(SoundState == null){
        SoundState = true;
      }else{
        SoundState = false;
      }
    }catch(err){
      SoundState = true;
    }
  }
  firsttimeCalled() async {
    GetLocationForUpdate();
    var Stage = int.parse(widget.Stage);
    if(Stage == null){
      Arrival = 0;
      DownBtn = 'من رسیدم';
    }else{
      CancelVisivle =false;
      if(Stage <= 4 && Stage >0){
        Arrival =Stage;
        DownBtn = widget.DownBtnText.toString();
      }else if(Stage == 6){
        DownBtn='اتمام سفر';
        IsTravelFinished = true;
      }else{
        Arrival = 0;
        DownBtn = 'من رسیدم';
      }
    }
  }
  getdata() async {
        Passengerid = widget.PassengerID.toString();
        OriginStr = widget.Origin.toString();
        DestinationStr = widget.Destination.toString();
        StartPoint = widget.OriginLoc.toString();
        EndPoint = widget.DestinationLoc.toString();
        StartLocationArray = StartPoint.split(',');
        StartLat= StartLocationArray[0];
        StartLong= StartLocationArray[1];
        EndLocationArray = EndPoint.split(',');
        EndLat= EndLocationArray[0];
        EndLong= EndLocationArray[1];
        SecondLocation = widget.SecLoc.toString();
        BackAndForthStr = widget.BackandForth.toString();
        TripIdStr = widget.TripId.toString();
        ConnectSocket();
        GetCancelResponse();
        GetMessageFromPassenger();
        GetEndTravelResponse();
        await GetNatCode();
        await GetPassengerName();
        TravelDetailes();
       // SetDriverIsOnline('1');
    if(IsTravelFinished == true){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  EndTravel(TripIdStr))),(Route<dynamic> route) => false);
    }
    return true;
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
  NavigationStart(var State) async {
    print(State);
    // Android
    var NvLat,NvLong;
    if(State == 0){
      NvLat = StartLat;
      NvLong = StartLong;
    }else if(State==1){
      NvLat = EndLat;
      NvLong = EndLong;

    }else if(State == 2){
      NvLat = EndLat;
      NvLong = EndLong;

  } else if(State == 3){
      var Array = SecondLocation.split(',');
      NvLat = Array[0];
      NvLong = Array[1];
    }else if(State == 4){
      NvLat = StartLat;
      NvLong = StartLong;
    }

    var url = 'geo:'+NvLat+','+NvLong;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // iOS
       url = 'http://maps.apple.com/?ll='+NvLat+','+NvLong;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
  DriverArrived() async {
    print('RRRRin');
    _openLoadingDialog(context);
    var PickupLatLong = await GetLocation();
    DiverArrivedMap['TripId'] = TripIdStr;
    DiverArrivedMap['pickup_lat_lng'] = PickupLatLong;
    DiverArrivedMap['start_lat_lng'] = EndPoint;
    DiverArrivedMap['UserId'] = Passengerid;
    socket.emit('DriverArrived', [jsonEncode(DiverArrivedMap)]);
    Navigator.pop(context);
    setState(() {
      DownBtn = 'مسافر سوار شد';
      Arrival=1;
      CancelVisivle =false;
    });
  }
  EndTravelF() async {
    _openLoadingDialog(context);
    var EndLoc = await GetLocation();
    EndTravelMap['TripId'] = TripIdStr;
    EndTravelMap['end_lat_lng'] = EndLoc;
    EndTravelMap['UserId'] = Passengerid;
    socket.emit('EndTravel', [jsonEncode(EndTravelMap)]);
    await deletePrefs();
    socket.clearListeners();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  EndTravel(TripIdStr))),(Route<dynamic> route) => false);
  }
  deletePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('Stage');
    prefs.remove('DownBtnText');
    prefs.remove('Passengerid');
    prefs.remove('OriginStr');
    prefs.remove('DestinationStr');
    prefs.remove('StartPoint');
    prefs.remove('EndPoint');
    prefs.remove('SecondLocation');
    prefs.remove('TripIdStr');
    prefs.remove('BackAndForthStr');
    socket.clearListeners();
    return true;
  }
  PassengerPickup() async {
    _openLoadingDialog(context);
    var PickupLatLong = await GetLocation();
    PassengerPickUp['TripId'] = TripIdStr;
    PassengerPickUp['pickup_lat_lng'] = PickupLatLong;
    PassengerPickUp['UserId'] = Passengerid;
    socket.emit('PassengetPickUp', [jsonEncode(PassengerPickUp)]);
    Navigator.pop(context);
    setState(() {
      if(SecondLocation != 'null'){
        DownBtn = 'رسیدن به مقصد اول';
        Arrival =3;
      }else
        {
          if(BackAndForthStr == '1'){
            DownBtn = 'بازگشت به مبدا';
            Arrival=4;
          }else{
            DownBtn = 'پایان سفر';
            Arrival =2;
          }
        }
    });
  }
  BackAndForth(){
    _openLoadingDialog(context);
    Map<String, dynamic> EndTravel = new Map();
    EndTravel['TripId'] = TripIdStr;
    EndTravel['UserId'] = Passengerid;
    socket.emit('BackAndForth', [jsonEncode(EndTravel)]);
    Navigator.pop(context);
    setState(() {
    DownBtn = 'پایان سفر';
    Arrival=2;
    });
  }
  ArriveTofirst() async {
    _openLoadingDialog(context);
    ArriveTofirstmap['TripId'] = TripIdStr;
    ArriveTofirstmap['UserId'] = Passengerid;
    socket.emit('ArriveToFirst', [jsonEncode(ArriveTofirst)]);
    Navigator.pop(context);
    setState(() {
      if(BackAndForthStr == '0'){
        DownBtn = 'پایان سفر';
        Arrival=2;
      }else{
        DownBtn = 'بازگشت به مبدا';
        Arrival=4;
      }
    });
  }
  CancelRequest(context) async {
    _openLoadingDialog(context);
  //  SetDriverIsOnline('1');
    CancelTripMap['TripId'] = TripIdStr;
    ArriveTofirstmap['UserId'] = Passengerid;
    CancelTripMap['canceledBy'] = 'Driver';
    socket.emit('CancelDriverToClient', [jsonEncode(CancelTripMap)]);
    Fluttertoast.showToast(
        msg: "سفر با موفقیت کنسل شد.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.yellow,
        textColor: Colors.black,
        fontSize: 16.0
    );
    await deletePrefs();
    socket.clearListeners();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  StartOfWork())),(Route<dynamic> route) => false);
  }
  GetCancelResponse(){
    socket.on('CanceledToDriver', (data) async =>
    CancelResponseBody(data)
    );
  }
  GetMessageFromPassenger(){
    socket.on('ListenToMessage', (data) async =>
        GetMessageFromDriverBody(data)
    );
  }
  GetPassengerName() async {
    FormData formData = FormData.fromMap({
      "UserId":Passengerid,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/GetDriverDesc",data:formData);
        PassengerNameFam = response.data['Name'] +' '+ response.data['Family'];
    } catch (e) {
      print(e);
    }
  }
  GetEndTravelResponse(){
    socket.on('TravelEndedClient', (data) async =>
        EndTravelResponseBody(data)
    );
  }
  GetNatCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    NatCode = prefs.getString('NationalCode');
  }
  EndTravelResponseBody(data) async {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  EndTravel(TripIdStr))),(Route<dynamic> route) => false);
  }
  GetMessageFromDriverBody(data) async {
    var DialogTxt='';
    var _ParsedData = await jsonDecode(data);
    var State = _ParsedData[0].toString();
    var Message = _ParsedData[1].toString();
    if(State == '0'){
      DialogTxt = ' ! منتظر هستم';
    }else if(State == '1'){
      DialogTxt = '! دارم میایم';
    }else if(State == '2'){
      DialogTxt = '! در محل حاظرم';
    }else if(State == '3'){
      DialogTxt = Message;
    }
    Alert(
      context: context,
      type: AlertType.none,
      title: "پیام کاربر",
      desc: DialogTxt,
      buttons: [
        DialogButton(
          child: Text(
            "تایید",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color:Colors.red,
        ),
      ],
    ).show();

  }
  CancelResponseBody(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SoundState = prefs.getBool('GuideSound');
    if(SoundState == null || SoundState =='null'){
      SoundState = true;
    }
 var _ParsedData = await jsonDecode(data.toString());
 var CancelBy = _ParsedData[1].toString();
if(_ParsedData[0] == TripIdStr){
  if(CancelBy == 'Passenger'){
    if(SoundState) {
      _audioCache.play('ride_cancelled_by_passenger.mp3');
    }
    Fluttertoast.showToast(
        msg: "سفر توسط مسافر کنسل شد.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.yellow,
        textColor: Colors.black,
        fontSize: 16.0
    );
    await deletePrefs();
   // SetDriverIsOnline('1');
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  StartOfWork())),(Route<dynamic> route) => false);
  }
}
}
  UpdateInTravelState() async {
    FormData formData = FormData.fromMap({
      "DriverID":NatCode,
      "State":'1',
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/UpdateDriverTripState",data:formData);
      if(response.data.toString() =="Updated"){
      }
    } catch (e) {
      print(e);
    }
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
  ConnectSocket() async {
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
  UpdateLoc(Latlong) async {
    FormData formData = FormData.fromMap({
      "DriverID":NatCode,
      "Latlong":Latlong,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/UpdateDriverLatLong",data:formData);
      if(response.toString() =='Updated'){
        return true;
      }
    } catch (e) {
      print(e);
    }
  }
  UpdateReadyTowork() async {
    FormData formData = FormData.fromMap({
      "DriverID":NatCode,
      "State":'0',
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/UpdateDriverReadyToWork",data:formData);
      if(response.toString() =='Updated'){
      }
    } catch (e) {
      print(e);
    }
  }
  Future GetLocationForUpdate() async {
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
    var lat = _locationData.latitude;
    var long = _locationData.longitude;
    String retvalue = lat.toString() + ',' + long.toString();
      UpdateDriverLat = lat.toString();
      UpdateDriverLong = long.toString();
    UpdateLoc(retvalue);
    return retvalue;
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
  var lat = _locationData.latitude;
  var long = _locationData.longitude;
  String  retvalue = lat.toString() + ',' + long.toString();
  return retvalue;
}

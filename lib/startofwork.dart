import 'dart:async';
import 'package:dio_retry/dio_retry.dart';
import 'package:sahanddriver/TravelRequest.dart';
import 'package:wakelock/wakelock.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'DrawerLayout.dart';
class StartOfWork extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StartOfWorkState();
  }

}

class StartOfWorkState extends State<StartOfWork> {
  var Name, DriverNumber, NatCode,PicrureUrl,dio;
  Future _future;
  Socket socket;
  Timer timer;
  Location location = new Location();
  String PresentLoc,Loca, Numbr ;

  @override
  initState() {
    super.initState();
    dio = Dio()..interceptors.add(RetryInterceptor(
        options: const RetryOptions(
          retries: 0, // Number of retries before a failure
          retryInterval: const Duration(seconds: 1000000), // Interval between each retry
        )
    ));
    _future =FetureBuilder();
    Wakelock.enable();
    timer = Timer.periodic(Duration(seconds: 20), (Timer t) => GetLocation());
  }
  @override
  void dispose() {
    timer?.cancel();
    socket.clearListeners();
    super.dispose();
  }
  final appbar = AppBar(
      backgroundColor: new Color(0xffffffff),
      elevation: 6.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(right: 1),
            child: new Text('در انتظار مسافر',
              style: TextStyle(color: Colors.black, fontSize: 20),),),
          Flexible(child: new Text('ارتباط با سرور \nوصل است',
            style: TextStyle(color: Colors.green, fontSize: 16), maxLines: 2,),
          ),
        ],
      ),
  );
  @override
  Widget build(BuildContext context) {
    var Array;
    // TODO: implement build
    return WillPopScope(child:
    Scaffold(
      body: new FutureBuilder(
        future:_future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData){
            Array = Loca.split(',');
          }
          return snapshot.hasData ?  new Scaffold(
              drawer: BuildDrawerLayout(context, Name, DriverNumber,PicrureUrl,'پایان کار',NatCode),
              appBar: appbar,
              body:  Center(
                child: FlutterMap(
                  options: new MapOptions(
                    center: new LatLng(
                        double.parse(Array[0]), double.parse(Array[1])),
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
                            width: 50,
                            height: 50,
                            point: new LatLng(double.parse(Array[0]), double.parse(Array[1])),
                            builder: (context) {
                              return new Container(
                                child: Image.asset('assets/images/drivermarker.png'),
                              );
                            }
                        ),
                      ],
                    ),
                  ],
                ),
              )
          ) : new Center(child: CircularProgressIndicator(),);
        },),
    ), onWillPop: () => Future(() => false));
  }
    UpdateTravelState(State) async {
    FormData formData = FormData.fromMap({
      "DriverID":NatCode,
      "State":State,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/UpdateDriverTripState",data:formData);
      if(response.data.toString() =="Updated"){
      return true;
      }
    } catch (e) {
      print(e);
    }
  }

  UpdateLoc(Latlong) async {
    FormData formData = FormData.fromMap({
      "DriverID":NatCode,
      "Latlong":Latlong,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/UpdateDriverLatLong",data:formData);
      if(response.toString() =='Updated'){
        setState(() {
        });
        return true;
      }
    } catch (e) {
      print(e);
    }
  }
  FetureBuilder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    NatCode = prefs.getString('NationalCode');
     Numbr = prefs.getString('UserNumber');
    await UpdateTravelStateoff('1');
    await UpdateTravelState('0');
    _ConnectSocket();
    _ListenToDriverAccept();
    await GetLocation();
    await GetDriverData();
    return true;
  }
  UpdateTravelStateoff(State) async {
    FormData formData = FormData.fromMap({
      "DriverID":NatCode,
      "State":State,
    });
    try {
      Response response = await dio.post('https://sahandtehran.ir:3000/DriverMain/UpdateDriverReadyToWork',data:formData);
      print('UpdateDriver'+response.toString());
      if(response.toString() =='Updated'){
        print('Worksss');
      }
    } catch (e) {
      print(e);
    }
  }
  GetDriverData() async {
    FormData formData = FormData.fromMap({
      "Number": Numbr,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/GetDriverData", data: formData);
      Name = response.data['FName'] + ' ' + response.data['LName'];
      DriverNumber = response.data['MobileNo'];
      PicrureUrl = response.data['PicURL'];
      return true;
    } catch (e) {
      print('erererer '+e);
    }
  }

//  void GetNatCode() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    NatCode = prefs.getString('NationalCode');
//  }
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
  _ListenToDriverAccept()  {
    socket.on('NewTripForDrivers', (data) =>
        GotoNext(data)
    );
  }
  void GotoNext(data) async {
    socket.clearListeners();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  TravelRequest(data))),(Route<dynamic> route) => true);
  }
  Future GetLocation() async {
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
    Loca = _locationData.latitude.toString() + ',' + _locationData.longitude.toString();
     UpdateLoc(Loca);
    return true;
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
}

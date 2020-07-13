import 'dart:async';
import 'dart:convert';
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
  var Name, DriverNumber, NatCode,PicrureUrl,DriverNat;
  Future _future;
  Socket socket;
  Timer timer;
  String PresentLoc;
  String Loca;
  var dio;
  @override
  initState() {
    super.initState();
    _ConnectSocket();
    _ListenToDriverAccept();
    _future =FetureBuilder();
    dio = Dio()..interceptors.add(RetryInterceptor(
        options: const RetryOptions(
          retries: 0, // Number of retries before a failure
          retryInterval: const Duration(seconds: 10), // Interval between each retry
        )
    ));
    Wakelock.enable();
    timer = Timer.periodic(Duration(seconds: 20), (Timer t) =>setstatefor());
    UpdateTravelDetails();

  }
  @override
  void dispose() {
    timer?.cancel();
    socket.disconnect();
    socket.destroy();
    SetDriverIsOnline('0');
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
        future:_future ,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData){
            print('Location' + PresentLoc);
            Array = PresentLoc.split(',');
          }
          return snapshot.hasData ?  new Scaffold(
              drawer: BuildDrawerLayout(context, Name, DriverNumber,PicrureUrl,'پایان کار'),
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

            ///start building your widget tree
          ) : new Center(child: CircularProgressIndicator(),);
          ///load until snapshot.hasData resolves to true
        },),
    ), onWillPop: () => Future(() => false));
  }

  // ignore: non_constant_identifier_names
  UpdateTravelState(State) async {
    print('UpdateIntravelStatefirstLine');
    FormData formData = FormData.fromMap({
      "DriverID":NatCode,
      "State":State,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/UpdateDriverTripState",data:formData);
      print('UpdateDriver '+response.data.toString());
      if(response.data.toString() =="Updated"){
        print('Ready TO Work Updated TO : : '+State);
      return true;
      }
    } catch (e) {
      print(e);
    }
  }
  UpdateTravelDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    NatCode = prefs.getString('NationalCode');
    print('Worked');
    await UpdateReadytoWork('1');
    await UpdateTravelState('0');
    await SetDriverIsOnline('1');
    print('Worked2');
  }
  UpdateLoc(Latlong) async {
    print('aaaaaaa');
    print(NatCode);
    print(Latlong);
    FormData formData = FormData.fromMap({
      "DriverID":NatCode,
      "Latlong":Latlong,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/UpdateDriverLatLong",data:formData);
      print('UpdateDriver'+response.toString());
      if(response.toString() =='Updated'){
        print('LocUpdatedTTT');
        return true;
      }
    } catch (e) {
      print(e);
    }
  }
  FetureBuilder() async {
    await GetLocation();
    await GetDriverData();
    return true;
  }
  UpdateReadytoWork(State) async {
    FormData formData = FormData.fromMap({
      "DriverID":NatCode,
      "State":State,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/UpdateDriverReadyToWork",data:formData);
      print('UpdateDriver'+response.toString());
      if(response.toString() =='Updated'){
        print('Ready TO Work Updated TO : : '+State);
      }
    } catch (e) {
      print(e);
    }
  }
   GetDriverData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Numbr = prefs.getString('UserNumber');
    print('StartworkNumber' + Numbr);
    FormData formData = FormData.fromMap({
      "Number": Numbr,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/GetDriverData", data: formData);
      print('StartworkResponse' + response.toString());
      Name = response.data['FName'] + ' ' + response.data['LName'];
      DriverNumber = response.data['MobileNo'];
      PicrureUrl = response.data['PicURL'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      NatCode = prefs.getString('NationalCode');
      await  GetLocation();
      print('NatCode' + NatCode +'  PicrureUrl'+PicrureUrl +'  DriverNumber'+DriverNumber +'   NameFamily'+Name);
      print('Balalola');
      return true;
    } catch (e) {
      print('erererer '+e);
    }
  }
  setstatefor(){
    print('SetStateCalled');
    setState(() {
      GetLocation();
    });
  }
  void GetNatCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    NatCode = prefs.getString('NationalCode');
    GetLocation();
  }
  _ConnectSocket() async {
    socket = io('https://sahandtehran.ir:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, // optional
    });
    socket.connect();
    socket.on('connect', (_) {

      print('FindRdiverSocketConnected');

    });
  }
  _ListenToDriverAccept()  {
    print('ListenStarted');
    socket.on('NewTripForDrivers', (data) =>
        GotoNext(data)
    );
  }
  void GotoNext(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('DataToPass',data);
    print('111'+data);
    Map<String, dynamic> user  = jsonDecode(data);
   print('DriverId = '+user['DriverId']);
    if(user['DriverId']== NatCode){
      socket.close();
      socket.destroy();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>new Directionality(textDirection: TextDirection.rtl, child:  TravelRequest())),(Route<dynamic> route) => true);
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
    String retvalue = lat.toString() + ',' + long.toString();
    Loca = retvalue;
     UpdateLoc(Loca);
    PresentLoc = retvalue;
    return retvalue;
  }

  SetDriverIsOnline(IsOnline) async {
    FormData formData = FormData.fromMap({
      "Driverid": NatCode,
      "DriverIsOnline":IsOnline,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/UpdateDriverOnlineState", data: formData);
      print(response);
      if(response.data.toString() == 'Updated'){

      }
      return true;
    } catch (e) {
      print(e);
    }
  }
}

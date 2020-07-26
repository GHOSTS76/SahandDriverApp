import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
class profliecar extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return profileCarState();
  }

}
class profileCarState extends State<profliecar> {
  Future _future;
  var VehicleBrandLU, VehicleModelLU, VehicleColorLU, UseTypeLU, PlateArray,Picture,VehicleCreateYear;
  bool IsActive;
  String VehiclePlate;
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
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData ? Scaffold(
            body: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Align(alignment: Alignment.topRight,
                        child: new Padding(
                          padding: EdgeInsets.only(right: 40, top: 10),
                          child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(Picture), radius: 50,),)),
                  ],
                ),
                new Align(
                  alignment: Alignment.center,
                  child:
                  Padding(padding: EdgeInsets.only(top: 10), child:Visibility(child: Container(
                    child: Center(
                        child:
                        Padding(padding: EdgeInsets.all(1),
                          child: new Text('اطلاعات شما منتظر تایید میباشد',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                    ),
                    width: 160,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xff9e9e9e),
                      borderRadius: BorderRadius.circular(55),
                    ),
                  ),visible: IsActive,)
                  ),
                ),
                new Align(
                    alignment: Alignment.center,
                    child: Container(
                      child:
                      Center(
                        child:
                        Padding(padding: EdgeInsets.only(top: 15),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text('دسته بندی :', style: TextStyle(
                                  color: Colors.black, fontSize: 16),),
                              new Text(UseTypeLU, style: TextStyle(
                                  color: Colors.grey, fontSize: 16),),
                            ],
                          ),
                        ),
                      ),
                    )
                ),
                new Align(
                    alignment: Alignment.center,
                    child: Container(
                      child:
                      Center(
                        child:
                        Padding(padding: EdgeInsets.only(top: 30),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text('برند :', style: TextStyle(
                                  color: Colors.black, fontSize: 16),),
                              new Text(VehicleBrandLU, style: TextStyle(
                                  color: Colors.grey, fontSize: 16),),
                            ],
                          ),
                        ),
                      ),
                    )
                ),
                new Align(
                    alignment: Alignment.center,
                    child: Container(
                      child:
                      Center(
                        child:
                        Padding(padding: EdgeInsets.only(top: 30),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text('مدل :', style: TextStyle(
                                  color: Colors.black, fontSize: 16),),
                              new Text(VehicleModelLU, style: TextStyle(
                                  color: Colors.grey, fontSize: 16),),
                            ],
                          ),
                        ),
                      ),
                    )
                ),
                new Align(
                    alignment: Alignment.center,
                    child: Container(
                      child:
                      Center(
                        child:
                        Padding(padding: EdgeInsets.only(top: 30),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text('رنگ :', style: TextStyle(
                                  color: Colors.black, fontSize: 16),),
                              new Text(VehicleColorLU, style: TextStyle(
                                  color: Colors.grey, fontSize: 16),),
                            ],
                          ),
                        ),
                      ),
                    )
                )
                ,
                new Align(
                    alignment: Alignment.center,
                    child: Container(
                      child:
                      Center(
                        child:
                        Padding(padding: EdgeInsets.only(top: 30),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text('سال :', style: TextStyle(
                                  color: Colors.black, fontSize: 16),),
                              new Text(VehicleCreateYear.toString(), style: TextStyle(
                                  color: Colors.grey, fontSize: 16),),
                            ],
                          ),
                        ),
                      ),
                    )
                ),
                new Align(
                    alignment: Alignment.center,
                    child: Container(
                      child:
                      Center(
                        child:
                        Padding(padding: EdgeInsets.only(top: 30),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text('پلاک :', style: TextStyle(
                                  color: Colors.black, fontSize: 16),),
                              new Text(VehiclePlate, style: TextStyle(
                                  color: Colors.grey, fontSize: 16),),
                            ],
                          ),
                        ),
                      ),
                    )
                )
              ],
            )
        ) : new Center(child: CircularProgressIndicator(),);
      },
    );
  }
 

  GetDriverData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Numbr = prefs.getString('UserNumber');
    FormData formData = FormData.fromMap({
      "Number": Numbr,
    });
    try {
      Response response = await dio.post("https://sahandtehran.ir:3000/DriverMain/GetDriverData", data: formData);
      VehiclePlate = response.data['VehiclePlate'];
      VehicleBrandLU = response.data['VehicleBrandLU'];
      VehicleModelLU = response.data['VehicleModelLU'];
      VehicleColorLU = response.data['VehicleColorLU'];
      VehicleCreateYear = response.data['VehicleCreateYear'];
      UseTypeLU = response.data['UseTypeLU'];
      IsActive = response.data['IsActive'];
      Picture = response.data['PicURL'];
      if(IsActive == true){
        IsActive = false;
      }
      PlateArray = VehiclePlate.split(',');
      VehiclePlate = PlateArray[0] +'_'+ PlateArray[3] +'_'+ PlateArray[1] +'_'+ PlateArray[2];
      return true;
    } catch (e) {
      print(e);
    }
  }

}
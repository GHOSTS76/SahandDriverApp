import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingState();
  }
}

class SettingState extends State<Setting>{
  bool _lights = false;
  @override
  void initState() {
    super.initState();
    getStringValuesSF();
  }
  final appbar = new AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor:  Color(0xff008860),
    elevation: 9.0,
    title: new Text('تنظیمات',style: TextStyle(fontSize: 20,color: Colors.white),),
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:SwitchListTile(
          activeColor: Colors.green,
          value: _lights,
          title:new Text('فعال کردن صدای راهنما',style: TextStyle(fontSize: 18,color: Colors.black),),
          onChanged: (bool value){
            setState(() {
              _lights = value;
              SaveSetting(value);
            });
          }
      ),
      appBar: appbar,
    );
  }
  SaveSetting(BtnState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('GuideSound', BtnState);
    print(BtnState);
  }
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool pref = prefs.getBool('GuideSound');
    if(pref == null){
      pref =false;
    }
    setState(() {
      _lights = pref;
    });
    print('PrefState = '+pref.toString());
  }
}





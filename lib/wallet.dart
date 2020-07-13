import 'package:flutter/material.dart';

class Wallet extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WalletState();
  }

}

class WalletState extends State<Wallet>{
  final appbar = AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor:  Color(0xff008860),
    elevation: 0.0,
    title: new Text('کیف اعتباری',style: TextStyle(fontSize: 20,color: Colors.white),),
  );
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      appBar: appbar,
      body: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: width,
            color:Color(0xff008860),
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(padding: EdgeInsets.only(bottom: 30,right: 20),child:      Container(
                          width: 170,
                          height: 55,
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:    new ListTile(
                            leading:
                            ImageIcon(
                              AssetImage("assets/images/plus.png"),
                              color: Colors.green,
                            ),
                            title: new Text('افزایش اعتبار',style:TextStyle(
                              fontSize: 18,
                              color:  Color(0xff008860),
                            )),
                            onTap: (){
                              Navigator.of(context).pushNamed('/Wallet');
                            },
                          ),
                        ),)
                    ),
                    new Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(padding:EdgeInsets.only(top: 100,right: 80),child:  new Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            children: <Widget>[
                              new Align(
                                alignment: Alignment.bottomLeft,
                                child:       Row(
                                  children: <Widget>[
                                    new Text('(اعتبار من)',style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                children: <Widget>[
                                  new Text('0'+' '+'ریال',style: TextStyle(
                                    color:  Color(0xffffb421),
                                    fontSize: 18,
                                  ),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  new Text('(بستانکار)',style: TextStyle(
                                    color:  Color(0xffffb421),
                                    fontSize: 18,
                                  ),
                                  )],
                              )
                            ],
                          ),
                        ),)
                    ),
                  ],
                )
              ],
            ),
          ),
          Card(
            child: Container(
              child: Column(
                
                children: <Widget>[
                  Container(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(right: 10),child:  new Text('1399/2/1 _ 16:32',style: TextStyle(color: Colors.black45,fontSize: 16),),),
                      ],
                    ),
                    height: 40,
                    color: const Color(0xffeeeeee),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(right: 10,top: 10),child: new Text('افزایش اعتبار',style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10,top: 10),child:  new Text('0 ریال',style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),),)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(right: 10,top: 10),child: new Text('پرداخت از طریق اعتبار',style: TextStyle(
                        color: Colors.black45,
                        fontSize: 20,
                      ),),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10,top: 10),child:Row(
                        children: <Widget>[
                          new Text('افزایش',style: TextStyle( color: Colors.black45,  fontSize: 20,),),
                          Image.asset('assets/images/inc.png',height: 20,width: 20,)
                        ],
                      ))],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(right: 10,top: 10),child: new Text('کد سفر 76788',style: TextStyle(
                        color: Colors.black45,
                        fontSize: 20,
                      ),),
                      ),
                    ],
                  )
                ],
              ),
              height: 210,
              color: Colors.white,
            ),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            margin: EdgeInsets.all(0),
            elevation: 0,
            color: Colors.white,
          )
        ],
      )




    );
  }

}
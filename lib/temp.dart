//import 'dart:math' show pi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'SearchPage/search2.dart';
import 'package:http/http.dart' as http;
import 'package:plaid/plaid.dart';
import 'dart:convert';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State <Home> {
  var _purchases = [];
  showPlaidView() {
    bool plaidSandbox = true;

    Configuration configuration = Configuration(
        plaidPublicKey: '014d4f2c01905eafa07cbcd2755ef5',
        plaidBaseUrl: 'https://cdn.plaid.com/link/v2/stable/link.html',
        plaidEnvironment: plaidSandbox ? 'sandbox' : 'production',
        environmentPlaidPathAccessToken:
        'https://sandbox.plaid.com/item/public_token/exchange',
        environmentPlaidPathStripeToken:
        'https://sandbox.plaid.com/processor/stripe/bank_account_token/create',
        plaidClientId: '',
        secret: plaidSandbox ? '' : '',
        clientName: 'ClientName',
        webhook: 'https://www.chezky.com/dope',
        products: 'auth,income',
        selectAccount: 'false'
    );

    FlutterPlaidApi flutterPlaidApi = FlutterPlaidApi(configuration);
    flutterPlaidApi.launch(context, (Result result) {
      print(result.token);
    }, stripeToken: false);
  }

  Widget _settingsIcon() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10,15,0,0),
      child: IconButton(
        icon:Icon(Icons.settings),
        onPressed: (){
          _getTransactions();
        },
        iconSize: 30,
      ),
    );
  }

  Widget _searchIcon() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0,15,10,0),
        child: IconButton(
          icon:Icon(Icons.search),
          onPressed: (){
            Navigator.of(context).push(_searchRoute());
//            Navigator.push(context, MaterialPageRoute(builder: (context)=> Search()));
          },
          iconSize: 30,
        ),
      ),
    );
  }

  Widget _charityContainer() {
    return AspectRatio(
      aspectRatio: 3/2.5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.deepPurple[300].withOpacity(0.2),
//          boxShadow: [
//            new BoxShadow(
//              color: Colors.black,
//              blurRadius: 3.0,
//            ),
//          ],
        ),
        margin: EdgeInsets.fromLTRB(50,80,50,20),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  image: DecorationImage(
                    image: AssetImage('images/org.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                margin: EdgeInsets.fromLTRB(0,0,0,20),
//                child: Image.asset('images/org.png'),
              ),
            ),
            RaisedButton(
              elevation: 8,
              child: Text('Sign In'),
              onPressed: () {
                showPlaidView();
                _testConnection();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionHistoryContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.white,
        ),
        child: _scrollingList(),
      ),
    );
  }

  Widget _scrollingList(){
    return ListView.builder(
      itemCount: _purchases.length == 0 ? 1 : _purchases.length,
      itemBuilder: (BuildContext context, int i){
        if(_purchases.length==0) {
          return Container(
            alignment: Alignment.center,
            width: 100,
            height: 400,
            child: Text('Nothing Here Yet'),
          );
        } else {
          return Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue[300].withOpacity(0.3),
                      ),
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Text(_purchases[i]["name"][0],
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          width: 200,
                          height: 22,
                          child: Text(
                            _purchases[i]["name"],
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                          width: 60,
                          height: 18,
                          child: Text(
                            "\$${_purchases[i]["amount"].toString()}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          '¢${_purchases[i]["change"].toString()}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 1,
                  width: 300,
                  color: Colors.grey[300],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CustomPaint(
            painter: myPainter(),
            child: Stack(
              children: <Widget>[
                _settingsIcon(),
                _searchIcon(),
                _charityContainer(),
                _transactionHistoryContainer(),
              ],
            ),
          ),
        ),
      ),
      extendBody: false,
    );
  }

  _testConnection() async {
    var content = 'dope';
    var response  = await http.post(_address()+'main', body: content);
    print(response.body);
  }

  _getTransactions() async {
    var content = 'dope';
    var response  = await http.post(_address()+'main', body: content);
    var responseDecode = json.decode(response.body);
    print(response.body);
    print(responseDecode["purchases"][0]);
    setState(() {
      _purchases = responseDecode["purchases"];
    });
  }

  String _address() {
    if(Platform.isAndroid)
      return 'http://10.0.2.2:8080/api/';
    else
      return 'http://localhost:8080/api/';
  }
  Route _searchRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Search2(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class myPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.purpleAccent[400].withOpacity(0.2), BlendMode.colorBurn);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
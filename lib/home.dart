//import 'dart:math' show pi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:plaid/plaid.dart';
import 'search.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State <Home> {

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
      itemCount: 8,
      itemBuilder: (BuildContext context, int i){
        return Container(
          width: MediaQuery.of(context).size.width,
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
                      child: Text('C',
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
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        width: 100,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        width: 60,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 45),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.2),
                    ),
                    child: Center(
                        child: Text(
                          '¢17',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple.withOpacity(0.1),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.green.withOpacity(0.8),
                      iconSize: 30,
                      onPressed: (){},
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
    var response  = await http.post(_address(), body: content);
    print(response.body);
  }

  String _address() {
    if(Platform.isAndroid)
      return 'http://10.0.2.2:8080/api/main';
    else
      return 'http://localhost:8080/opapp/signup';
  }
  Route _searchRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Search(),
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
//    final path = Path()
//      ..moveTo(0, 0)
////      ..lineTo(200, 200)
//      ..quadraticBezierTo(0,400,100,500)
//      ..quadraticBezierTo(0, 400, size.width/2, 0);
//    final paint = Paint()
//      ..color = Colors.purpleAccent[400]
//      ..style = PaintingStyle.fill
//      ..strokeWidth = 4;
//    canvas.drawPath(path, paint);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:plaid/plaid.dart';
import 'paintings.dart';
import 'home.dart';

class SignUp extends StatefulWidget{
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin{
  Animation<Offset> animation;
  Animation<Offset> animationB;
  AnimationController controller;
  double drawTime = 0.0;
  double drawDuration = 1.8;
  DateTime selectedDate = DateTime(2012);
  bool _clickedDob;
  String plaidToken;

  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(seconds: drawDuration.toInt()));

    animation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    ));
    animationB = Tween<Offset>(
      begin: Offset(2.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    ));
    Future<void>.delayed(Duration(milliseconds: 0), () {
      controller.forward();
      print(animation.value);
    });
  }

  Widget _backButton() {
   return Container(
     margin: EdgeInsets.only(top: 20, left: 10),
     alignment: Alignment.centerLeft,
     child: IconButton(
       icon: Icon(Icons.arrow_back),
       iconSize: 30,
       onPressed: (){
         Navigator.pop(context);
       },
     ),
   );
  }

  Widget _signUpText() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).viewInsets.bottom > 345 ? 30 : 60),
      alignment: Alignment.center,
      child: Text(
        'Sign Up',
        style: TextStyle(
          fontSize: 55,
        ),
      ),
    );
  }

  Widget _emailInput() {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, top: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [BoxShadow(
          color: Colors.grey[350],
          blurRadius: 20.0,
          offset: Offset.fromDirection(0.9),
        ),],
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: "Email",
          hasFloatingPlaceholder: false,
          prefixIcon:  _emailPrefix(),
        ),
      ),
    );
  }

  Widget _emailPrefix() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 15),
      child: Icon(
        Icons.email,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _passInput() {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, top: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [BoxShadow(
          color: Colors.grey[350],
          blurRadius: 20.0,
          offset: Offset.fromDirection(0.9),
        ),],
      ),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Password",
          hasFloatingPlaceholder: false,
          prefixIcon:  _passPrefix(),
          suffixIcon:  _passSuffix(),
        ),
      ),
    );
  }

  Widget _passPrefix() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 15),
      child: Icon(
        Icons.lock,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _passSuffix() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 25),
      child: Icon(
        Icons.remove_red_eye,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _dobInput() {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
        setState(() {
          _clickedDob = true;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        margin: EdgeInsets.only(right: 20, left: 20, top: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [BoxShadow(
            color: Colors.grey[350],
            blurRadius: 20.0,
            offset: Offset.fromDirection(0.9),
          ),],
        ),
        child: _dobToggle(),
      ),
    );
  }

  Widget _dobToggle(){
    if(_clickedDob == null) {
      return Row(
        children: <Widget>[
          _dobIcon(),
          Text(
            'Date of Birth',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 15,
            ),
          ),
        ],
      );    }
    else{
      return Row(
        children: <Widget>[
          _dobIcon(),
          Text(
            selectedDate.month.toString(),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              selectedDate.day.toString(),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              selectedDate.year.toString(),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    }
  }

  _dobIcon() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 15),
      child: Icon(
        Icons.cake,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _plaidButton() {
    return GestureDetector(
      onTap: () {
        if (plaidToken == null || plaidToken == ''){
          showPlaidView();
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              plaidToken = '';
            });
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        margin: EdgeInsets.only(right: 20, left: 20, top: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [BoxShadow(
            color: Colors.grey[350],
            blurRadius: 20.0,
            offset: Offset.fromDirection(0.9),
          ),],
        ),
        child: Row(
          children: <Widget>[
            _linkIcon(),
            _plaidStatus(),
          ],
        ),
      ),
    );
  }

  Widget _linkIcon() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 15),
      child: Icon(
        Icons.link,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  Widget  _plaidStatus() {
    if(plaidToken != '' && plaidToken != null){
      return Text(
        'Connected',
        style: TextStyle(
          color: Colors.green,
        ),
      );
    } else if(plaidToken == null) {
      return Text(
        'Link Your Bank Account',
      );
    } else {
      return Text(
        'Not Connected',
        style: TextStyle(
          color: Colors.red,
        ),
      );
    }
  }

  Widget _signUpButton() {
    return Container(
      margin: EdgeInsets.only(right: 20, top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 35,
              ),
            ),
          ),
          Container(
            child: RaisedButton(
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context)=> Home())
                );
              },
              padding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(60))),
              child: Ink(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.lightBlue[400], Colors.lightBlue[300]],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(30.0)
                ),
                child: Icon(Icons.arrow_forward, color: Colors.white,size: 30,),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SlideTransition(
          position: animation,
          child: CustomPaint(
            painter: SignUpPaint(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SlideTransition(
                position: animationB,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _backButton(),
                      _signUpText(),
                      _emailInput(),
                      _passInput(),
                      _dobInput(),
                      _plaidButton(),
                      _signUpButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1940, 8),
      lastDate: DateTime(2013)
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

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
      setState(() {
        plaidToken = result.token;
      });
      print(result.token);
    }, stripeToken: false);
  }
}
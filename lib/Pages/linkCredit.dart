import 'dart:async';
import 'dart:convert';

import 'package:change/Pages/linkBank.dart';
import 'package:change_charity_components/change_charity_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'homePage.dart';
import 'package:flutter_stripe_payment/flutter_stripe_payment.dart';

import '../Components/securityFaq.dart';

class LinkCredit extends StatefulWidget{
  @override
  _LinkCreditState createState()=>_LinkCreditState();
}

class _LinkCreditState extends State<LinkCredit> with TickerProviderStateMixin{

  AnimationController _controller;
  Animation<Offset> _topDown;
  Animation<Offset> _bottomUp;
  Animation<Offset>_rightToLeft;
  Animation<Color> _animationC;

  AnimationController controllerC;

  String token;
  String name = "";
  String logo = "";
  String _paymentMethodId;
  String plaidToken;
  String accountId;
  String bankName;
  String _plaidErr = '';
  int id;
  int mask;
  bool loading = false;

  GlobalConfiguration cfg = new GlobalConfiguration();
  final _stripePayment = FlutterStripePayment();

  void initState(){
    super.initState();
    _stripePayment.setStripeSettings(
        "pk_live_4emYzSEoyJOFgpVOaEqy6j2L00p4wofNb8", "{STRIPE_APPLE_PAY_MERCHANTID}");
    _stripePayment.onCancel = () {
      print("the payment form was cancelled");
    };

    _controller = AnimationController(vsync: this, duration: Duration(seconds:2));
    controllerC = AnimationController(
        vsync: this, duration: Duration(seconds: 1));


    _topDown = Tween<Offset>(
      begin: Offset(-1.0, -2.0),
      end:Offset(0.0,0.0),
    ).animate(CurvedAnimation(
        parent:_controller,
        curve:Curves.fastLinearToSlowEaseIn
    )
    );

    _bottomUp = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end:Offset(0.0,0.0),
    ).animate(CurvedAnimation(
        parent:_controller,
        curve:Curves.fastLinearToSlowEaseIn
    )
    );

    _rightToLeft = Tween<Offset>(
      begin:Offset(1.0, 0.0),
      end:Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent:_controller,
      curve:Curves.fastLinearToSlowEaseIn,
    )
    );

    _animationC = controllerC.drive(
        ColorTween(begin: Colors.lightBlue[200], end: Colors.lightBlue[600]));
    controllerC.repeat();


    Future<void>.delayed(Duration(milliseconds:1000),(){
      _controller.forward();
    });

  }

  Widget _securedBy() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline),
          Text(
            " Secured by "
          ) ,
          Padding(
            padding: EdgeInsets.only(top: 3),
            child: Image.asset(
              "images/stripe-logo.png",
              alignment: Alignment.bottomCenter,
              height: 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon() {
    return GestureDetector(
      onTap: () => _openCredit(),
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
        child: Container(
          width: 115,
          height: 115,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light ? Colors.grey[100] : Colors.grey[900],
            boxShadow:  [BoxShadow(
                color: MediaQuery
                    .of(context)
                    .platformBrightness == Brightness.light ? Colors
                    .grey[300] : Colors.grey[700],
                offset: Offset.fromDirection(1),
                blurRadius: 15),
            ],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.credit_card,
            size: 50,
          ),
        ),
      ),
    );
  }

  Widget _linkYourText() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.04, bottom: 15),
      child: Text(
        'Link your Payment Method',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _explainText() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.001, left: MediaQuery.of(context).size.width* 0.1, right: MediaQuery.of(context).size.width* 0.1),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          children: [
            TextSpan(
              style: TextStyle(
                height: 1.5,
                fontSize: 15,
                color: Theme.of(context).textTheme.caption.color,
              ),
              text:'To donate your round-ups, link a credit card to your Change Charity Account. This information is secured and protected by ',
            ),
            WidgetSpan(
              child: Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: Image.asset(
                  "images/stripe-logo.png",
                  alignment: Alignment.bottomCenter,
                  height: 16,
                ),
              ),
            ),
            TextSpan(
              style: TextStyle(
                height: 1.5,
                fontSize: 15,
                color: Theme.of(context).textTheme.caption.color,
              ),
              text:'.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _errCont() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: 40,
          right: 40,
          top: 2,
          bottom: 3,
        ),
        child: Text(
          '$_plaidErr',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _whySecure() {
    return Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.1, top: 40),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return SecurityFAQ();
              },
              fullscreenDialog: true
          ));
        },
        child: Text(
          "Security FAQ",
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _submitCont() {
    return ChangeSubmitRow(
      loading: loading,
      onClick: _linkAccount,
      text: _paymentMethodId == "" || _paymentMethodId == null ? "Link" : "Loading",
      animation: _animationC,
    );
  }

  Widget _skipText() {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: MediaQuery.of(context).size.height < 650 ? 20: 30, left: 30, right: 30),
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          _chooseLater();
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            "I will connect my payment method later",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey[50] : Colors.grey[850],
        title: Text(
          "Step One",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey[50] : Colors.grey[850],
      body: Material(
        child: SafeArea(
          child:SlideTransition(
            position:_rightToLeft,
            child:Container(
              height:MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: <Widget>[
                    SlideTransition(position:_topDown, child: _securedBy()),
                    Expanded(child: Container(),),
                    _icon(),
                    _linkYourText(),
                    _explainText(),
                    _whySecure(),
                    Expanded(child: Container(),),
                    SlideTransition(position:_bottomUp, child: _submitCont()),
                    _errCont(),
                    Expanded(child: Container(),),
                    SlideTransition(position:_bottomUp, child: _skipText()),
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future _openCredit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _plaidErr='';
    });
    if (_paymentMethodId == null || _paymentMethodId == '') {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _paymentMethodId = '';
        });
      });
    }

    var paymentResponse = await _stripePayment.addPaymentMethod();

    setState(() {
      if (paymentResponse.status ==
          PaymentResponseStatus.succeeded) {
        _paymentMethodId = paymentResponse.paymentMethodId;
        loading = true;
        _checkAndApply();
      } else {
        _plaidErr = "Invalid card";
      }
    });
    print("payment id is: $_paymentMethodId");
  }

  void _checkAndApply() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    token=prefs.getString('token');
    var content = '{"user_token":"$token"}';
    var response = await http.post("${cfg.getString("host")}/users/genephemeraltoken", body: content);
    var decodedRes = jsonDecode(response.body);
    var intentResponse = await _stripePayment.setupPaymentIntent(
        decodedRes["token"], _paymentMethodId);

    if (intentResponse.status == PaymentResponseStatus.succeeded) {
      print(_paymentMethodId);
    } else if (intentResponse.status == PaymentResponseStatus.failed) {
      setState(() {
        _plaidErr ="Issue verifying your card. Please try a different card.";
        _paymentMethodId = '';
        loading = false;
      });
    } else {
      _plaidErr ="Issue verifying your card at this time. Either try a different card, or try again later.";
      loading = false;
    }
  }

  Future _linkAccount() async {
    await _openCredit();

    if(_paymentMethodId == '' || _paymentMethodId == null){
      setState(() {
        _plaidErr = 'Click here to link your card';
        loading = false;
      });
      return;
    }

    SharedPreferences prefs=await SharedPreferences.getInstance();
    token=prefs.getString('token');
    var content = '{"user_token":"$token"}';
    var response = await http.post("${cfg.getString("host")}/users/checkcuslinkedcard", body: content);
    if (response.body == "success") {
      setState(() {
        loading = false;
      });

      prefs.setString('linkBank', null);
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>LinkBank()));
    } else {
      print(response.body);
      setState(() {
        loading = false;
        _plaidErr = 'There was an error linking your credit card at this time. Either try a different account, or try to re-link this card in a few hours';
      });
    }
  }

  void _chooseLater() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString('linkBank', null);
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>HomePage()));
  }
}
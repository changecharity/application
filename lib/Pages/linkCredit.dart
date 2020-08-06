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

  Widget _linkBankText() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.03, left: 20, right: 20),
      child: Text(
        'Connect Your Payment Method',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _reasonText() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, MediaQuery.of(context).size.height*0.04,30,0),
      child: Text(
        'Link your credit card so you can be charged for your donations.',
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 20,
          wordSpacing: 2,
        ),
      ),
    );
  }

  Widget _plaidButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).unfocus();
          _plaidErr='';
        });
        if (_paymentMethodId == null || _paymentMethodId == '') {
          _openCredit();
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              _paymentMethodId = '';
            });
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        margin: EdgeInsets.only(right: 20, left: 20, top: MediaQuery.of(context).size.height * 0.07),
        decoration: BoxDecoration(
          color:  MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.white : Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: MediaQuery.of(context).platformBrightness == Brightness.light ?  Colors.grey[350] : Colors.grey[600],
              blurRadius: 20.0,
              offset: Offset.fromDirection(0.9),
            ),
          ],
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
      ),
    );
  }

  //Changes on account connection or disconnect
  Widget _plaidStatus() {
    if (_paymentMethodId != '' && _paymentMethodId != null) {
      return Text(
        'Connected',
        style: TextStyle(
          color: Colors.green,
        ),
      );
    } else if (_paymentMethodId == null) {
      return Text(
        'Link Your Credit Card',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
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
      margin: EdgeInsets.only(left: 45, top: 10),
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
          "Why am I linking a payment method?",
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
      text: "Next Step",
      animation: _animationC,
    );
  }

  Widget _skipText() {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: MediaQuery.of(context).size.height < 650 ? 40: 40, left: 30, right: 30),
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
              fontSize: 19,
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
      body: SafeArea(
        child:SlideTransition(
            position:_rightToLeft,
            child:Container(
              height:MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:Column(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: <Widget>[
//                    SlideTransition(position:_topDown, child:_secureText()),
                    SlideTransition(position:_topDown, child: _linkBankText()),
                    _reasonText(),
                    _plaidButton(),
                    _errCont(),
                    _whySecure(),
                    Expanded(child: Container(),),
                    SlideTransition(position:_bottomUp, child: _submitCont()),
                    Expanded(child: Container(),),
                    SlideTransition(position:_bottomUp, child: _skipText()),
                  ]
              ),
            )
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openCredit() async {
    var paymentResponse = await _stripePayment.addPaymentMethod();
    setState(() {
      if (paymentResponse.status ==
          PaymentResponseStatus.succeeded) {
        _paymentMethodId = paymentResponse.paymentMethodId;
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
      });
    } else {
      _plaidErr ="Issue verifying your card at this time. Either try a different card, or try again later.";
    }
  }

  void _linkAccount() async {
    if(_paymentMethodId == '' || _paymentMethodId == null){
      setState(() {
        _plaidErr = 'Click here to link your card';
      });
      return;
    }

    setState(() {
      loading = true;
    });

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
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:change_charity_components/change_charity_components.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'homePage.dart';

import '../Components/securityFaq.dart';

class LinkBank extends StatefulWidget{
  @override
  _LinkBankState createState()=>_LinkBankState();
}

class _LinkBankState extends State<LinkBank> with TickerProviderStateMixin{

  AnimationController _controller;
  Animation<Offset> _topDown;
  Animation<Offset> _bottomUp;
  Animation<Offset>_rightToLeft;
  Animation<Color> _animationC;

  AnimationController controllerC;

  String token;
  String name = "";
  String logo = "";
  String plaidGenToken;
  String plaidPublicToken;
  String accountId;
  String bankName;
  String _plaidErr = '';
  int id;
  int mask;
  bool loading = false;

  GlobalConfiguration cfg = new GlobalConfiguration();
  PlaidLink _plaidLinkToken;

  void initState(){
    super.initState();
    _setPlaid();

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
        'Connect Your Round-Up Account',
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
        'Link your credit card account so you can have your monthly transactions be rounded up.',
        textAlign: TextAlign.left,
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
        if(plaidPublicToken == null || plaidPublicToken == ''){
          if(plaidGenToken != null && plaidGenToken != "") {
            _plaidLinkToken.open();
          } else {
            setState(() {
              _plaidErr ='Please wait a few seconds and try again.';
            });
          }
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              plaidPublicToken = '';
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
    if (plaidPublicToken != '' && plaidPublicToken != null) {
      return Text(
        'Connected',
        style: TextStyle(
          color: Colors.green,
        ),
      );
    } else if (plaidPublicToken == null) {
      return Text(
        'Link Your Credit Card Account',
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
          "I thought I just linked my credit card?",
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
      onClick: _addAccount,
      text: "Finish",
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
            "I will connect my round-up account later",
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
            "Step Two",
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
    controllerC.dispose();
    super.dispose();
  }

  Future<void> _getToken() async {
    var device;
    if(Platform.isAndroid) {
      device = "android";
    } else {
      device = "ios";
    }

    print(device);

    SharedPreferences prefs=await SharedPreferences.getInstance();
    token=prefs.getString('token');
    var content = '{"user_token":"$token", "device":"$device"}';
    var response = await http.post("${cfg.getString("host")}/users/createlinktoken", body: content);
    var decodedRes = jsonDecode(response.body);
    setState(() {
      plaidGenToken = decodedRes["linkToken"];
    });
  }

  void _chooseLater() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString('linkBank', null);
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>HomePage()));
  }

  Future<void> _setPlaid() async{
    await _getToken();
    print("plaid gen token is $plaidGenToken");

    setState(() {
      LinkConfiguration linkTokenConfiguration = LinkConfiguration(
        linkToken: plaidGenToken,
      );

      _plaidLinkToken = PlaidLink(
        configuration: linkTokenConfiguration,
        onSuccess: _onSuccessCallback,
        onEvent: _onEventCallback,
        onExit: _onExitCallback,
      );
    });
  }

  void _onSuccessCallback(publicToken, metadata) {
    setState(() {
      _plaidErr = '';
    });
    print("onSuccess: $publicToken, metadata: ${metadata.description()}");

    var account;
    var accounts=metadata.accounts;

    print(accounts);

    for(int i=0; i<accounts.length; i++){
      if(accounts[i].subtype=="credit card"){
        account=accounts[i];
        print(account);
      }
    }

    if(account == null) {
      setState(() {
        _plaidErr = "You must link a Credit Card Account, and not just a Checking Account";
      });
    }

    bankName = metadata.institutionName;
    mask = int.parse(account.mask);
    accountId = account.id;

    setState(() {
      plaidPublicToken = publicToken;
    });

    print(bankName);

  }

  void _onEventCallback(event, metadata) {
    print("onEvent: $event, metadata: ${metadata.description()}");
  }

  void _onExitCallback(error, metadata) {
    print("onExit: $error, metadata: ${metadata.description()}");
  }

  bool _checkValidPlaid(){
    if(plaidPublicToken==null|| plaidPublicToken==''){
      setState(() {
        _plaidErr="Click here to link your credit card account";
      });
      return false;
    }
    return true;
  }

  _addAccount() async {
    if (!_checkValidPlaid()) {
      print(_plaidErr);
      return;
    }

    setState(() {
      loading=!loading;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(token);
    print(bankName);
    var content = '{"user_token":"$token", "plaid_public_token":"$plaidPublicToken", "plaid_account_id":"$accountId", "mask":$mask, "bank_name":"$bankName"}';
    var response = await http.post("${cfg.getString("host")}/users/addcard", body: content);

    print(response.body);
    setState(() {
      loading = !loading;
    });
    if (response.body.contains('no rows in')){
      setState(() {
        _plaidErr = "This account is already linked";
        plaidPublicToken = "";
      });
      return;
    } else if (response.body == "success") {
      Navigator.pushAndRemoveUntil(
          context, PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage()), (
          route) => false);
    } else {
      setState(() {
        _plaidErr = "There was an error linking your bank account at this time. Either try a different account, or try to re-link this account in a few hours";
        plaidPublicToken = "";
      });
    }
  }
}
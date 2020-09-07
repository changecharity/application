import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:change_charity_components/change_charity_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/securityFaq.dart';
import 'homePage.dart';

class LinkBank extends StatefulWidget {
  @override
  _LinkBankState createState() => _LinkBankState();
}

class _LinkBankState extends State<LinkBank> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _topDown;
  Animation<Offset> _bottomUp;
  Animation<Offset> _rightToLeft;
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

  void initState() {
    super.initState();
    _setPlaid();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    controllerC =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _topDown = Tween<Offset>(
      begin: Offset(-1.0, -2.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn));

    _bottomUp = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn));

    _rightToLeft = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    _animationC = controllerC.drive(
        ColorTween(begin: Colors.lightBlue[200], end: Colors.lightBlue[600]));
    controllerC.repeat();

    Future<void>.delayed(Duration(milliseconds: 1000), () {
      _controller.forward();
    });
  }

  Widget _securedBy() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline),
          Text(" Secured by "),
          Padding(
            padding: EdgeInsets.only(top: 3),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? "images/plaid-logo.png"
                  : "images/plaid-logo-white.png",
              alignment: Alignment.bottomCenter,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon() {
    return GestureDetector(
      onTap: () => _openPlaid(),
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
        child: Container(
          width: 115,
          height: 115,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[100]
                : Colors.grey[900],
            boxShadow: [
              BoxShadow(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Colors.grey[300]
                      : Colors.grey[700],
                  offset: Offset.fromDirection(1),
                  blurRadius: 15),
            ],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.account_balance,
            size: 50,
          ),
        ),
      ),
    );
  }

  Widget _linkYourText() {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.04, bottom: 15),
      child: Text(
        'Connect Your Credit Card Account',
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
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.001,
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          children: [
            TextSpan(
              style: TextStyle(
                height: 1.5,
                fontSize: 14.5,
                color: Theme.of(context).textTheme.caption.color,
              ),
              text:
                  'To enable Change Charity to compute your round-ups, link a Credit Card Account. This information is secured and protected by ',
            ),
            WidgetSpan(
              child: Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? "images/plaid-logo.png"
                      : "images/plaid-logo-white.png",
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
              text: '.',
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
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.1, top: 40),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return SecurityFAQ();
              },
              fullscreenDialog: true));
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
      onClick: _openPlaid,
      text: plaidPublicToken == "" || plaidPublicToken == null
          ? "Connect"
          : "Loading",
      animation: _animationC,
    );
  }

  Widget _skipText() {
    return Container(
      margin: EdgeInsets.only(
          top: 0,
          bottom: MediaQuery.of(context).size.height < 650 ? 20 : 30,
          left: 30,
          right: 30),
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          _chooseLater();
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            "I will connect my Credit Card Account later",
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
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.grey[50]
                : Colors.grey[850],
        title: Text(
          "Step Two",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.grey[50]
              : Colors.grey[850],
      body: SafeArea(
        child: SlideTransition(
            position: _rightToLeft,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SlideTransition(position: _topDown, child: _securedBy()),
                    Expanded(
                      child: Container(),
                    ),
                    _icon(),
                    _linkYourText(),
                    _explainText(),
                    _whySecure(),
                    Expanded(
                      child: Container(),
                    ),
                    SlideTransition(position: _bottomUp, child: _submitCont()),
                    _errCont(),
                    Expanded(
                      child: Container(),
                    ),
                    SlideTransition(position: _bottomUp, child: _skipText()),
                  ]),
            )),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    controllerC.dispose();
    super.dispose();
  }

  Future<void> _openPlaid() async {
    if (plaidPublicToken == null || plaidPublicToken == '') {
      if (plaidGenToken != null && plaidGenToken != "") {
        _plaidLinkToken.open();
      } else {
        setState(() {
          _plaidErr = 'Please wait a few seconds and try again.';
        });
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          plaidPublicToken = '';
        });
      });
    }
  }

  Future<void> _getToken() async {
    var device;
    if (Platform.isAndroid) {
      device = "android";
    } else {
      device = "ios";
    }

    print(device);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var content = '{"user_token":"$token", "device":"$device"}';
    var response = await http
        .post("${cfg.getString("host")}/users/createlinktoken", body: content);
    var decodedRes = jsonDecode(response.body);
    setState(() {
      plaidGenToken = decodedRes["link_token"];
    });
  }

  void _chooseLater() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('linkBank', null);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  Future<void> _setPlaid() async {
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
    var accounts = metadata.accounts;

    print(accounts);

    for (int i = 0; i < accounts.length; i++) {
      if (accounts[i].subtype == "credit card") {
        account = accounts[i];
        print(account);
      }
    }

    if (account == null) {
      setState(() {
        _plaidErr =
            "You must link a Credit Card Account, and not just a Checking Account";
      });
    }

    bankName = metadata.institutionName;
    mask = int.parse(account.mask);
    accountId = account.id;

    setState(() {
      plaidPublicToken = publicToken;
      loading = true;
    });

    print(bankName);

    _addAccount();
  }

  void _onEventCallback(event, metadata) {
    print("onEvent: $event, metadata: ${metadata.description()}");
  }

  void _onExitCallback(error, metadata) {
    print("onExit: $error, metadata: ${metadata.description()}");
  }

  bool _checkValidPlaid() {
    if (plaidPublicToken == null || plaidPublicToken == '') {
      setState(() {
        _plaidErr = "Click here to connect your credit card account";
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(token);
    print(bankName);
    var content =
        '{"user_token":"$token", "plaid_public_token":"$plaidPublicToken", "plaid_account_id":"$accountId", "mask":$mask, "bank_name":"$bankName"}';
    var response = await http.post("${cfg.getString("host")}/users/addcard",
        body: content);

    print(response.body);
    setState(() {
      loading = false;
    });
    if (response.body.contains('no rows in')) {
      setState(() {
        _plaidErr = "This account is already linked";
        plaidPublicToken = "";
      });
      return;
    } else if (response.body == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage()),
          (route) => false);
    } else {
      setState(() {
        _plaidErr =
            "There was an error linking your bank account at this time. Either try a different account, or try to re-link this account in a few hours";
        plaidPublicToken = "";
      });
    }
  }
}

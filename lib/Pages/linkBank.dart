import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'homePage.dart';
import '../paintings.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

class LinkBank extends StatefulWidget{
  final org;
  LinkBank(this.org);

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
  String plaidToken;
  String accountId;
  String bankName;
  String _plaidErr = '';
  int id;
  int mask;
  bool loading = false;

  GlobalConfiguration cfg = new GlobalConfiguration();
  PlaidLink _plaidLink;

  void initState(){
    super.initState();

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

    _plaidLink = PlaidLink(
      clientName: "Change Client",
      publicKey: "014d4f2c01905eafa07cbcd2755ef5",
      env: EnvOption.sandbox,
      products: <ProductOption>[
        ProductOption.transactions,
      ],
      language: "en",
      countryCodes: ['US'],
      onAccountLinked: (publicToken, metadata) => _onSuccess(publicToken, metadata),
      onAccountLinkError: (error, metadata) {
        print("onAccountLinkError: $error metadata: $metadata");
        setState(() {
          _plaidErr = "An error occurred. Please contact us for more assistance.";
        });
      },
      onEvent: (event, metadata) {
        print("onEvent: $event metadata: $metadata");
      },
      onExit: (metadata) {
        print("onExit: $metadata");
        setState(() {
          _plaidErr = "Please link a bank account";
        });
      },
    );
  }

  Widget _secureText() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
              Icons.lock,
          ),
          Text(
            'Secure',
          ),
        ],
      ),
    );
  }

  Widget _linkBankText() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
      child: Text(
        'Connect Your Bank',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _reasonText() {
    return Container(
      margin: EdgeInsets.fromLTRB(45, MediaQuery.of(context).size.height*0.08,45,0),
      child: Text(
        'To start donating${widget.org != "" ? ' to the ' +  widget.org : ''}, you must link your bank account',
        textAlign: TextAlign.center,
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
        if (plaidToken == null || plaidToken == '') {
          _plaidLink.open(
//             publicToken: "",
          );
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
        margin: EdgeInsets.only(right: 20, left: 20, top: MediaQuery.of(context).size.height * 0.1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[350],
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
        color: Colors.black,
      ),
    );
  }

  //Changes on account connection or disconnect
  Widget _plaidStatus() {
    if (plaidToken != '' && plaidToken != null) {
      return Text(
        'Connected',
        style: TextStyle(
          color: Colors.green,
        ),
      );
    } else if (plaidToken == null) {
      return Text(
        'Link Your Bank Account',
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

  Widget _submitCont() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 30),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height > 700 ? 70 : 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _continueText(),
            _continueButton(),
          ],
        ),
      ),
    );
  }

  Widget _continueText() {
    return Container(
      margin: EdgeInsets.fromLTRB(10,10,10,0),
      child: Text(
        'Submit',
        style: TextStyle(
          fontSize: 33,
        ),
      ),
    );
  }

  Widget _continueButton() {
    if (loading) {
      return Container(
        margin: EdgeInsets.fromLTRB(42, 0, 32, 0),
        child: CircularProgressIndicator(
          valueColor: _animationC,
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(0,10,20,0),
        child: RaisedButton(
          onPressed: () {
            _linkAccount();
          },
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(60))),
          child: Ink(
            width: 90,
            height: 50,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue[400], Colors.lightBlue[300]],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      );
    }
  }

  Widget _skipText() {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: MediaQuery.of(context).size.height < 650 ? 40: 40),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _chooseLater();
            },
            child: Container(
              child: Text(
                "I will connect my account later",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
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
        child:SlideTransition(
            position:_rightToLeft,
            child:CustomPaint(
                painter: SearchPaint(),
                child:Container(
                  height:MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child:Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      children: <Widget>[
                        SlideTransition(position:_topDown, child:_secureText()),
                        SlideTransition(position:_topDown, child: _linkBankText()),
                        _reasonText(),
                        _plaidButton(),
                        _errCont(),
                        Expanded(child: Container(),),
                        SlideTransition(position:_bottomUp, child: _submitCont()),
                        Expanded(child: Container(),),
                        SlideTransition(position:_bottomUp, child: _skipText()),
                      ]
                  ),
                )
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

  bool _checkPlaid() {
    if (plaidToken == '' || plaidToken == null) {
      setState(() {
        _plaidErr = 'Click here to connect your bank account';
      });
      return false;
    }
    return true;
  }

  void _linkAccount() async {
    if(!_checkPlaid()){
      return;
    }

    setState(() {
      loading = true;
    });

    SharedPreferences prefs=await SharedPreferences.getInstance();
    token=prefs.getString('token');
    var content = '{"user_token":"$token", "plaid_public_token":"$plaidToken", "plaid_account_id":"$accountId", "mask":$mask, "bank_name":"$bankName"}';
    var response = await http.post("${cfg.getString("host")}/users/updatebankacc", body: content);
    if (response.body == "success") {
      setState(() {
        loading = false;
      });

      prefs.setString('linkBank', null);
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>HomePage()));
    } else {
      setState(() {
        loading = false;
        _plaidErr = 'There was an error linking your bank account at this time. Either try a different account, or try to re-link this account in a few hours';
      });
    }
  }

  void _chooseLater() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString('linkBank', null);
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>HomePage()));
  }

   _onSuccess (publicToken, metadata) {
    var account;
    var accounts=metadata["accounts"];

    for(int i=0; i<accounts.length; i++){
      if(accounts[i]["subtype"]=="checking"){
        account=accounts[i];
        print(account);
      }
    }

    print(metadata.toString());

    setState(() {
      plaidToken = publicToken;
    });
    accountId=(account["id"]);
    mask = int.parse(account["mask"]);
    bankName = metadata["institution_name"];

    print("$accountId, $mask, $bankName");
  }
}
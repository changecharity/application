import 'dart:async';
import 'dart:convert';
import'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plaid/plaid.dart';


class ChangeAccDialog extends StatefulWidget {
  @override
  _ChangeAccDialogState createState() => _ChangeAccDialogState();

  final String password;
  ChangeAccDialog(this.password);

}

class _ChangeAccDialogState extends State<ChangeAccDialog>with SingleTickerProviderStateMixin{

  String plaidToken;
  String accountId;
  String bankName;
  int mask;
  String _plaidErr='';
  var token;
  bool loading=false;
  Animation<Color> loadingAn;
  AnimationController loadingController;

  void initState(){
    super.initState();

    loadingController= AnimationController(
        vsync: this, duration: Duration(seconds: 1));
    loadingAn = loadingController.drive(
        ColorTween(begin: Colors.lightBlue[200], end: Colors.lightBlue[600]));

    loadingController.repeat();
  }

  Widget _accountText(){
    return Column(
      children: <Widget>[
        Text(
            'Bank Information',
            style:TextStyle(
                fontSize: 24,
                fontWeight:FontWeight.bold
            )
        ),
        Container(
          margin: EdgeInsets.only(top:10),
          child:Text(
              'Please click on the button to enter your account information',
              textAlign: TextAlign.center,
              style:TextStyle(
                fontSize: 14,
              )
          ),
        ),
      ],
    );
  }

  Widget _plaidButton() {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              FocusScope.of(context).unfocus();
              _plaidErr='';
            });
            if (plaidToken == null || plaidToken == '') {
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
            margin: EdgeInsets.only(right: 20, left: 20, ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[350],
                  blurRadius: 5.0,
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
        ),
        _plaidErr==null||_plaidErr==''?Container():_errorContainer(),
      ],
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

  Widget _errorContainer() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: 40,
          top: 2,
          bottom: 3,
        ),
        child: Text(
          _plaidErr,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  //
  Widget _linkCont(context) {
    return Container(
      margin: EdgeInsets.only(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Link Account',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          _linkButton(context)
        ],
      ),
    );
  }

  Widget _linkButton(context){
    if(loading){
      return Container(
          margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
          child:CircularProgressIndicator(
            valueColor:loadingAn,
          )
      );
    }
    return Container(
      child: RaisedButton(
        onPressed: (){
          FocusScope.of(context).unfocus();
          _changeAccount();
        },
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(60))),
        child: Ink(
          width: 86,
          height: 40,
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        onTap:() {
          FocusScope.of(context).unfocus();
        },
        child:Dialog(
            backgroundColor: Colors.grey[100],
            elevation:15,
            shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
            child:Container(
                height:MediaQuery.of(context).size.height*.4,
                padding:EdgeInsets.symmetric(vertical:20, horizontal:10),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _accountText(),
                    _plaidButton(),
                    _linkCont(context)
                  ],
                )
            )
        )
    );
  }

  //handle showing the plaid api
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
        webhook: 'https://changecharity.io/api/plaidwebhook',
        products: 'auth,income',
        selectAccount: 'false');

    FlutterPlaidApi flutterPlaidApi = FlutterPlaidApi(configuration);
    flutterPlaidApi.launch(context, (Result result) {
      setState(() {
        plaidToken = result.token;
      });
      print(result.response);
      print(result.institutionName);
      var accounts=jsonDecode(result.response["accounts"]);
      accountId=(accounts[0]["_id"]);
      mask = int.parse(accounts[0]["meta"]["number"]);
      bankName = result.institutionName;

      print(mask);
      print(result.token);
    }, stripeToken: false);
  }

  bool _checkValidPlaid(){
    if(plaidToken==null|| plaidToken==''){
      setState(() {
        _plaidErr="You must link a bank";
      });
      return false;
    }
    return true;
  }


  _changeAccount() async {
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
    var content = '{"user_token":"$token", "password":"${widget
        .password}", "plaid_public_token":"$plaidToken", "plaid_account_id":"$accountId", "mask":$mask, "bank_name":"$bankName"}';
    var response = await http.post("https://api.changecharity.io/users/updatebankacc", body: content);
    print(response.body);

    if (response.body.contains('rpc error: code = Unknown desc = {"code":"bank_account_exists","doc_url":"https://stripe.com/docs/error-codes/bank-account-exists')){
      setState(() {
        loading=!loading;
        _plaidErr = "This account is already linked";
      });
      return;
    } else if (response.body == "success") {
      //make another api call to get profile
      Navigator.of(context).pop();
    }
  }

}
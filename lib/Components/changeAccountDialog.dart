import 'dart:async';

import'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:provider/provider.dart';

import '../Models/userBankModel.dart';

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

  PlaidLink _plaidLink;

  void initState(){
    super.initState();

    loadingController= AnimationController(
        vsync: this, duration: Duration(seconds: 1));
    loadingAn = loadingController.drive(
        ColorTween(begin: Colors.lightBlue[200], end: Colors.lightBlue[600]));

    loadingController.repeat();

    _plaidLink = PlaidLink(
      clientName: "Change Client",
      publicKey: "014d4f2c01905eafa07cbcd2755ef5",
      env: EnvOption.production,
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

  Widget _accountText(){
    return Column(
      children: <Widget>[
        Text(
            'Bank Information',
            style:TextStyle(
                fontSize: 20,
                fontWeight:FontWeight.bold
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20,25,20,0),
          child:Text(
              'Please click on the button below and enter your account details',
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
              _plaidLink.open(
                // publicToken: "...",
              );
              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  plaidToken = '';
                });
              });
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 60,
            margin: EdgeInsets.only(right: 5, left: 5, top: 40 ),
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
      margin: EdgeInsets.only(left: 20, right: 10),
      child: Icon(
        Icons.link,
        size: 22,
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
        'Link Your Checking Account',
        style:TextStyle(fontSize:12)
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
          right: 40,
          top: 2,
          bottom: 3,
        ),
        child: Text(
          _plaidErr,
          style: TextStyle(
            color: Colors.red,
            letterSpacing: 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  //
  Widget _linkCont(context) {
    return Container(
      margin: EdgeInsets.only(top:20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
//            child: Text(
//              'Link Account',
//              style: TextStyle(
//                fontSize: 20,
//              ),
//            ),
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
          width: 90,
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
    return GestureDetector(
        onTap:() {
          FocusScope.of(context).unfocus();
        },
        child:Dialog(
            backgroundColor: Colors.grey[100],
            elevation:15,
            shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
            child:Container(
                //height:MediaQuery.of(context).size.height*.4,
                padding:EdgeInsets.symmetric(vertical:20, horizontal:10),
                child:Column(
                  mainAxisSize:MainAxisSize.min,
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
    var content = '{"user_token":"$token", "password":"${widget.password}", "plaid_public_token":"$plaidToken", "plaid_account_id":"$accountId", "mask":$mask, "bank_name":"$bankName"}';
    var response = await http.post("https://api.changecharity.io/users/updatebankacc", body: content);

    print(response.body);
    if (response.body.contains('rpc error: code = Unknown desc = {"code":"bank_account_exists","doc_url":"https://stripe.com/docs/error-codes/bank-account-exists')){
      setState(() {
        loading=!loading;
        _plaidErr = "This account is already linked";
      });
      return;
    } else if (response.body == "success") {
      //save bank info in provider
      var pfL = context.read<UserBankModel>().getPfLetter;
      context.read<UserBankModel>().notify(mask.toString(), bankName, pfL);

      Navigator.of(context).pop();
    } else {
      setState(() {
        loading=!loading;
        _plaidErr = "There was an error linking your bank account at this time. Either try a different account, or try to re-link this account in a few hours";
      });
    }
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
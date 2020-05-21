import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:plaid/plaid.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'paintings.dart';
import 'emailAuth.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  Animation<Offset> animation;
  Animation<Offset> animationB;
  Animation<Color> loadingAn;
  AnimationController controller;
  AnimationController loadingController;
  double drawTime = 0.0;
  double drawDuration = 1.8;
  //DateTime selectedDate = DateTime(2012);
  //bool _clickedDob;
  String plaidToken;
  String accountId;
  final _passController= TextEditingController();
  final _emailController= TextEditingController();
  String _passErr='';
  String _emailErr='';
  String _plaidErr='';
  bool obscurePass=true;
  bool loading=false;

  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: Duration(seconds: drawDuration.toInt()));
    loadingController= AnimationController(
        vsync: this, duration: Duration(seconds: 1));

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
    loadingAn = loadingController.drive(
        ColorTween(begin: Colors.lightBlue[200], end: Colors.lightBlue[600]));

    loadingController.repeat();

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
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _signUpText() {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).viewInsets.bottom > 345 ? 30 : 60),
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey[350],
            blurRadius: 20.0,
            offset: Offset.fromDirection(0.9),
          ),
        ],
      ),
      child: TextField(
        controller:_emailController,
        onChanged: (s){
          setState(() {
            _emailErr='';
          });
        },
        decoration: InputDecoration(
          labelText: "Email",
          hasFloatingPlaceholder: false,
          prefixIcon: _emailPrefix(),
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
  Widget _errCont(String error) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: 40,
          top: 2,
          bottom: 3,
        ),
        child: Text(
           error,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  Widget _passInput() {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20),
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
      child: TextField(
        controller:_passController,
        obscureText: obscurePass,
        onChanged: (s){
          setState(() {
            _passErr='';
          });
        },
        decoration: InputDecoration(
          labelText: "Password",
          hasFloatingPlaceholder: false,
          prefixIcon: _passPrefix(),
          suffixIcon: _passSuffix(),
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
      child: IconButton(
        onPressed:(){
          setState(() {
            obscurePass=!obscurePass;
          });
        },
        icon:Icon(
          obscurePass?Icons.visibility:Icons.visibility_off,
          size: 20,
          color: Colors.black,
        )

      ),
    );
  }


  Widget _plaidButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
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

  Widget _signUpCont() {
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
          _signUpButton()
        ],
      ),
    );
  }

  Widget _signUpButton(){
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
          _signUp();
        },
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(60))),
        child: Ink(
          width: 100,
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
                      _errCont(_emailErr),
                      _passInput(),
                      _errCont(_passErr),
                      _plaidButton(),
                      _errCont(_plaidErr),
                      _signUpCont(),
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

//  Future<Null> _selectDate(BuildContext context) async {
//    final DateTime picked = await showDatePicker(
//        context: context,
//        initialDate: selectedDate,
//        firstDate: DateTime(1940, 8),
//        lastDate: DateTime(2013));
//    if (picked != null && picked != selectedDate)
//      setState(() {
//        selectedDate = picked;
//      });
//  }

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
      var accounts=jsonDecode(result.response["accounts"]);
      accountId=(accounts[0]["_id"]);
      print(result.token);
    }, stripeToken: false);
  }

  void _saveSignUp(val) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString('token', val);
   if(prefs.getString('token')!=null&&prefs.getString('token')!=''){
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>EmailAuth()));
    }
  }

  bool _checkValidEmail() {

    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text);

    if(_emailController.text==''||_emailController.text==null){
      setState((){
        _emailErr="This field can't be blank";
      });
      return false;
    } else if(!emailValid){
      setState((){
        _emailErr="This is not a valid email address";
      });
      return false;
    }
    return true;

  }

  bool _checkValidPassword(){

    bool containsCap = RegExp(r"[A-Z]").hasMatch(_passController.text);
    var containsNumb=RegExp(r"\d").hasMatch(_passController.text);
    //regex not working for this.have to fix:
    var containsSpecialChar=RegExp(r"^\W").hasMatch(_passController.text);
    if (_passController.text ==''|| _passController.text==null){
      setState((){
        _passErr="This field can't be blank";
      });
      return false;
    }else if(_passController.text.length<6) {
      setState(() {
        _passErr = "Must be longer than 6 characters";
      });
      return false;
    }else if(!containsCap){
      setState(() {
        _passErr="Must contain at least one capital letter";
      });
      return false;
    } else if(!containsNumb){
      setState(() {
        _passErr="Must contain at least one number";
      });
      return false;
    }
    return true;

  }

  bool _checkValidPlaid(){
    if(plaidToken==null|| plaidToken==''){
      _plaidErr="You must link a bank";
      return false;
    }
    return true;
  }

  _signUp()async{
    if(!_checkValidEmail()){
      setState(() {
        return;
      });
    }else if(!_checkValidPassword()){
      setState(() {
        return;
      });
    } else if(!_checkValidPlaid()){
      setState(() {
        return;
      });
    }else{
      setState(() {
        loading=!loading;
      });
      var content='{"email":"${_emailController.text}","password":"${_passController.text}", "plaid_public_token":"$plaidToken", "plaid_account_id":"$accountId"}';
      var response= await http.post("https://changecharity.io/api/users/signup", body:content);

      print(response.body);

      if(response.body=="rpc error: code = Unknown desc = email exists"){
        setState(() {
          _emailErr="Email Taken";
          loading=!loading;
        });
        return;
      } else if(response.body.startsWith("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9")&&plaidToken!=null&&plaidToken!=''){
        _saveSignUp(response.body);
        print("successful");
      }

    }
  }

}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'paintings.dart';
import 'homePage.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  Animation<Offset> animation;
  Animation<Offset> animationB;
  Animation<Color> animationC;
  AnimationController controller;
  AnimationController controllerC;

  final _emailController=TextEditingController();
  final _passController = TextEditingController();
  final emailFocusNode=FocusNode();
  final  passFocusNode =FocusNode();
  String _emailErr = '';
  String _passErr = '';


  double drawTime = 0.0;
  double drawDuration = 2.0;
  double loadDuration = 1;

  bool obscurePass=true;
  bool loading = false;

  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: Duration(seconds: drawDuration.toInt()));
    controllerC = AnimationController(
        vsync: this, duration: Duration(seconds: loadDuration.toInt()));

    animation = Tween<Offset>(
      begin: Offset(-1.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
    animationB = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    animationC = controllerC.drive(
        ColorTween(begin: Colors.lightBlue[200], end: Colors.lightBlue[600]));

    controllerC.repeat();

    Future<void>.delayed(Duration(milliseconds: 500), () {
      controller.forward();
      print(MediaQuery.of(context).viewInsets.bottom);
    });
  }

  Widget _helloContainer() {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).viewInsets.bottom == 0
              ? 140
              : MediaQuery.of(context).viewInsets.bottom < 100
                  ? MediaQuery.of(context).viewInsets.bottom
                  : 0),
      alignment: Alignment.center,
      child: Text(
        'Hello',
        style: TextStyle(
          fontSize: 95,
          letterSpacing: -5,
        ),
      ),
    );
  }

  Widget _messageContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: Text(
        'Sign in to your account',
        style: TextStyle(
          fontSize: 25,
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
        controller: _emailController,
        onChanged: (s) {
          setState(() {
            _emailErr = '';
          });
        },
        onEditingComplete: (){
            emailFocusNode.nextFocus();
        },
        decoration: InputDecoration(
          labelText: "Email",
          hasFloatingPlaceholder: false,
          prefixIcon: _emailPrefix(),
        ),
        focusNode:emailFocusNode
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

  Widget _emailErrCont() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: 40,
          top: 2,
          bottom: 3,
        ),
        height: 25,
        child: Text(
          _emailErr,
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
      margin: EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 0),
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
        obscureText: obscurePass,
        controller: _passController,
        onChanged: (s) {
          setState(() {
            _passErr = '';
          });
        },
        onEditingComplete:(){
          FocusScope.of(context).unfocus();
          _submit();
        },
        decoration: InputDecoration(
          labelText: "Password",
          hasFloatingPlaceholder: false,
          prefixIcon: _passPrefix(),
          suffixIcon: _passSuffix(),
        ),
        focusNode:passFocusNode
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
          obscurePass ? Icons.visibility : Icons.visibility_off,
          size: 20,
          color: Colors.black,
        )

      ),
    );
  }

  Widget _passErrCont() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: 40,
          top: 2,
          bottom: 3,
        ),
        child: Text(
          _passErr,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _forgotPass() {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(right: 35, top: 0),
      child: Text(
        'Forgot your password?',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _signinContainer() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(right: 20, top: 40),
        width: 250,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 35,
                ),
              ),
            ),
            _signinButton(),
          ],
        ),
      ),
    );
  }

  Widget _signinButton() {
    if (loading) {
      return Container(
        margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
        child: CircularProgressIndicator(
          valueColor: animationC,
        ),
      );
    } else {
      return Container(
        child: RaisedButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            _submit();

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
  }

  Widget _createText() {
    return Container(
      margin: EdgeInsets.only(top: 70),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text(
              "Don't have an account?",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 20,
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
      child:GestureDetector(
        onTap:(){
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child:SingleChildScrollView(
            child: SlideTransition(
              position: animationB,
              child: CustomPaint(
                painter: LoginPaint(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: SlideTransition(
                    position: animation,
                    child: Column(
                      children: <Widget>[
                        _helloContainer(),
                        _messageContainer(),
                        _emailInput(),
                        _emailErrCont(),
                        _passInput(),
                        _passErrCont(),
                        _forgotPass(),
                        _signinContainer(),
                        _createText(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    controller.dispose();
    controllerC.dispose();
    super.dispose();
  }


  void _saveLogin(val) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', val);
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>HomePage()));
  }

  void _saveEmailAddress(val) async{
    SharedPreferences emailPrefs=await SharedPreferences.getInstance();
    emailPrefs.setString('emailAddress', val);
  }

  bool _checkValidEmail(){

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

  _submit() async{

    if(!_checkValidEmail()) {
      print(_emailErr);
      return;
    }else if(!_checkValidPassword()){
      print(_passErr);
      return;
    }

    setState(() {
      loading=!loading;
    });

    var content = '{"email": "${_emailController.text}", "password":"${_passController.text}"}';
    var response = await http.post("https://api.changecharity.io/users/login", body:content);
    print(response.body);

    switch(response.body){
      case "rpc error: code = Unknown desc = Wrong Email":{
        setState((){
          _emailErr="An account with this email does not exist";
          loading=!loading;
        });
        return ;
      }
      break;
      case "rpc error: code = Unknown desc = Wrong Password":{
        setState((){
          _passErr="Wrong Password";
          loading=!loading;

        });
        return;
      }
      break;
    }

    if(response.body.startsWith("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9")){
      _saveLogin(response.body);
      _saveEmailAddress(_emailController.text);
      print("successful");
    }

    print(response.body);

  }
}


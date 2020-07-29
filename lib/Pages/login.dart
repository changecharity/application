import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'homePage.dart';
import '../Components/enterEmailDialog.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:change_charity_components/change_charity_components.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  GlobalConfiguration cfg = new GlobalConfiguration();

  Animation<Offset> animation;
  Animation<Offset> animationB;
  Animation<Offset> animationD;
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

    animationD = Tween<Offset>(
      begin: Offset(-2.0, -2.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    Future<void>.delayed(Duration(milliseconds: 700), () {
      controller.forward();
      print(MediaQuery.of(context).viewInsets.bottom);
    });
  }

  Widget _helloContainer() {
    if (MediaQuery.of(context).viewInsets.bottom == 0){
      return Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height < 650 ? 70 : MediaQuery.of(context).size.height * 0.16, bottom: 10),
        alignment: Alignment.center,
        child: Image.asset(
          "images/logo-circle.png",
          width: 150,
          height: 150,
        ),
      );
    }
    return Container();
  }

  Widget _messageContainer() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).viewInsets.bottom == 0
          ? 10
          : MediaQuery.of(context).viewInsets.bottom < 100
          ? MediaQuery.of(context).viewInsets.bottom
          : 150),
      alignment: Alignment.center,
      child: MediaQuery.of(context).viewInsets.bottom == 0 ? Text(
        'Sign in to your account',
        style: TextStyle(
          fontSize: 25,
        ),
      ) : Text(
        'Welcome Back',
        style: TextStyle(
          fontSize: 29,
        ),)
    );
  }

  Widget _emailInput() {
    return ChangeTextInput(
      controller: _emailController,
      focusNode: emailFocusNode,
      hintText: "Email",
      prefixIcon: Icons.mail,
      errMsg: _emailErr,
      errFunc: (String s) {
        setState(() {
          _emailErr = s;
        });
      },
    );
  }

  Widget _passInput() {
    return ChangeTextInput(
      controller: _passController,
      focusNode: passFocusNode,
      hintText: "Password",
      prefixIcon: Icons.lock,
      errMsg: _passErr,
      isPassword: true,
      last: true,
      errFunc: (String s) {
        setState(() {
          _passErr = s;
        });
      },
      lastFunc: _submit,
    );
  }

  Widget _forgotPass() {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(right: 35, top: 0),
      child: GestureDetector(
        onTap:(){
          showDialog(context:context, builder:(context)=>EnterEmail(), barrierDismissible: true);
        },
        child:Text(
          'Forgot your password?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      )
    );
  }

  Widget _signinContainer() {
    return ChangeSubmitRow(
      animation: animationC,
      loading: loading,
      text: MediaQuery.of(context).size.height > 700 ? "Sign In" : '',
      onClick: _submit,
    );
  }

  Widget _createText() {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: MediaQuery.of(context).size.height < 650 ? 3: 30),
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey[50],
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Material(
      child:GestureDetector(
        onTap:(){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: SlideTransition(
            position: animationB,
            child: CustomPaint(
              painter: ChangeLoginPaint(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SlideTransition(
                  position: animation,
//                  child: AutofillGroup(
                    child: Column(
                      children: <Widget>[
                        SlideTransition(child: _helloContainer(), position: animationD),
                        _messageContainer(),
                        Container(height: 50,),
                        _emailInput(),
                        _passInput(),
                        _forgotPass(),
                        _signinContainer(),
                        Expanded(child: Text(""),),
                        _createText(),
                      ],
                    ),
//                  ),
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


    if (_passController.text ==''|| _passController.text==null){
      setState((){
        _passErr="This field can't be blank";
      });
      return false;
    }
      return true;

  }

  _submit() async {
    print(_emailController.text);
    if (!_checkValidEmail()) {
      print(_emailErr);
      return;
    }
    else if (!_checkValidPassword()) {
      print(_passErr);
      return;
    }

    setState(() {
      loading = !loading;
      print("loading");
    });

    var content = '{"email": "${_emailController
        .text}", "password":"${_passController.text}"}';
    try {
      var response = await http.post("${cfg.getString("host")}/users/login", body: content)
          .catchError((e) => print("error is $e"));
      print(response.body);
      switch (response.body) {
        case "rpc error: code = Unknown desc = Wrong Email":
          {
            setState(() {
              _emailErr = "An account with this email does not exist";
              loading = !loading;
            });
            return;
          }
          break;
        case "rpc error: code = Unknown desc = Wrong Password":
          {
            setState(() {
              _passErr = "Incorrect Password";
              loading = !loading;
            });
            return;
          }
          break;
      }

      if (response.body.startsWith("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9")) {
        _saveLogin(response.body);
        _saveEmailAddress(_emailController.text);
        print("successful");
      } else if (response.body.contains("invalid character")) {
        setState(() {
          _emailErr = "Please remove any tabs";
          loading = !loading;
        });
      } else {
        setState(() {
          loading = !loading;
        });
      }

      print(response.body);
    } on TimeoutException catch(err) {
      print(err);
      setState(() {
        loading = !loading;
      });
    } on SocketException catch(err) {
      print(err);
      setState(() {
        loading = !loading;
      });
    } on NoSuchMethodError catch(err) {
      print(err);
      setState(() {
        loading = !loading;
      });
    }
  }
}


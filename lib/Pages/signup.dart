import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:plaid/plaid.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../paintings.dart';
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

  final _nameController= TextEditingController();
  final _passController= TextEditingController();
  final _emailController= TextEditingController();
  final _confirmPassController= TextEditingController();
  final nameFocusNode=FocusNode();
  final emailFocusNode=FocusNode();
  final passFocusNode=FocusNode();
  final confirmPassFocusNode=FocusNode();
  final tosFocusNode=FocusNode();
  String _nameErr='';
  String _passErr='';
  String _confirmPassErr = '';
  String _emailErr='';
  bool obscurePass=true;
  bool loading=false;
  bool _tosAccepted = false;

  void initState() {
    super.initState();

    //set animations
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

    Future<void>.delayed(Duration(milliseconds:500), () {
      controller.forward();
      print(animation.value);
    });
  }

  //back icon, takes back to login page
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

  //Sign Up
  Widget _signUpText() {
    if(MediaQuery.of(context).viewInsets.bottom != 0) {
      return Text("");
    }
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).viewInsets.bottom == 0
          ? MediaQuery.of(context).size.height < 700 ? 0 : MediaQuery.of(context).size.height *0.05
          : 0),
      alignment: Alignment.center,
      child: Text(
        'Sign Up',
        style: TextStyle(
          fontSize: 55,
        ),
      ),
    );
  }

  Widget _nameInput() {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, top: MediaQuery.of(context).viewInsets.bottom == 0
          ? MediaQuery.of(context).size.height>700 ? 80 :MediaQuery.of(context).size.height *0.06
          : 0),
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
        controller:_nameController,
        onChanged: (s){
          setState(() {
            _nameErr='';
          });
        },
        onEditingComplete: (){
          nameFocusNode.nextFocus();
        },
        decoration: InputDecoration(
          labelText: "Legal Name",
          hasFloatingPlaceholder: false,
          prefixIcon: _namePrefix(),
        ),
        focusNode: nameFocusNode,
        textInputAction:TextInputAction.next
      ),
    );
  }

  Widget _namePrefix() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 15),
      child: Icon(
        Icons.person,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  //email input
  Widget _emailInput() {
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
        controller:_emailController,
        onChanged: (s){
          setState(() {
            _emailErr='';
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
        focusNode: emailFocusNode,
        textInputAction:TextInputAction.next,
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

  //error container to use for email, pass, or plaid
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

  //password input
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
        onEditingComplete: (){
          FocusScope.of(context).requestFocus(confirmPassFocusNode);
        },
        decoration: InputDecoration(
          labelText: "Password",
          hasFloatingPlaceholder: false,
          prefixIcon: _passPrefix(),
          suffixIcon: _passSuffix(),
        ),
        focusNode: passFocusNode,
        textInputAction:TextInputAction.next
      ),
    );
  }

  //password input
  Widget _confirmPassInput() {
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
        controller:_confirmPassController,
        obscureText: obscurePass,
        onChanged: (s){
          setState(() {
            _confirmPassErr='';
          });
        },
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        decoration: InputDecoration(
          labelText: "Confirm Password",
          hasFloatingPlaceholder: false,
          prefixIcon: _passPrefix(),
          suffixIcon: _passSuffix(),
        ),
        focusNode: confirmPassFocusNode,
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

  //visibility suffix
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

  Widget _tosPrivacyCont() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Row(
        children: [
          Checkbox(
            value: _tosAccepted,
            checkColor: Colors.lightBlue[900],
            activeColor: Colors.orange[200],
            focusColor: Colors.red[500],
            autofocus: true,
            focusNode: tosFocusNode,
            onChanged: (bool newVal) {
              setState(() {
                _tosAccepted = !_tosAccepted;
              });
            },
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'I agree to the ',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Terms',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()..onTap = () => _launchURL("https://changecharity.io/terms-of-service"),
                ),
                TextSpan(
                  text: ' and ',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()..onTap = () => _launchURL("https://changecharity.io/privacy-policy"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Sign up button. Switches to loading on load
  Widget _signUpCont() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(right: 20, top:0, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _signUpEnterText(),
          _signUpButton(),
        ],
      ),
    );
  }

  Widget _signUpEnterText() {
    if(MediaQuery.of(context).size.height > 700) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 35,
          ),
        ),
      );
    } else {
      return Container();
    }
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
          if(_tosAccepted) {
            FocusScope.of(context).unfocus();
            _signUp();
          } else {
            tosFocusNode.hasFocus;
          }
        },
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        elevation: _tosAccepted ? 10 : 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(60))),
        child: Ink(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _tosAccepted ? [Colors.lightBlue[400], Colors.lightBlue[300]] : [Colors.grey[400], Colors.grey[400]],
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

  //page layout
  @override
  Widget build(BuildContext context) {
    return Material(
      child:GestureDetector(
        onTap:(){
          FocusScope.of(context).unfocus();
        },
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
                        _nameInput(),
                        _errCont(_nameErr),
                        _emailInput(),
                        _errCont(_emailErr),
                        _passInput(),
                        _errCont(_passErr),
                        _confirmPassInput(),
                        _errCont(_confirmPassErr),
                        _tosPrivacyCont(),
                        _signUpCont(),
                      ],
                    ),
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
    loadingController.dispose();
    super.dispose();
  }

  //uses SharedPreferences to set token on sign up.
  //If token available(sign up successful), pushes to verify page
  void _saveSignUp(val) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString('token', val);
    prefs.setString('signUpEmail', "${_emailController.text}");
   if(prefs.getString('token')!=null&&prefs.getString('token')!=''){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=>EmailAuth(_emailController.text, "signup")), (route) => false);
    }
  }

  //sets the time plus thirty minutes to store in shared preferences.
  //On verify page, after 30 minutes, get redirected back to sign up. account is no longer valid.
  void _setTime()async{
    var timePlusThirty=DateTime.now().add(new Duration(seconds:1800));
    SharedPreferences timePref =await SharedPreferences.getInstance();
    timePref.setString('time', timePlusThirty.toString());
    print(timePlusThirty.toString());
  }

  bool _checkValidName() {

    if(_nameController.text==''||_nameController.text==null){
      setState((){
        _nameErr="This field can't be blank";
      });
      return false;
    }
    return true;
  }

  //throws errors if email isn't valid
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

  //throws errors if password isn't valid
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
    } else if(_passController.text != _confirmPassController.text) {
      setState(() {
        _confirmPassErr= "Passwords do not match";
      });
      return false;
    }
    return true;

  }

  //called on click of sign up button. checks email, password, and plaid before making api call and signing up.
  //if sign up is successful, api sends back token which gets stored in shared preferences
  _signUp()async{
    if(!_checkValidName() || !_checkValidEmail() || !_checkValidPassword()){
      return;
    }else{
      setState(() {
        loading=!loading;
      });
      var content='{"legal_name":"${_nameController.text}","email":"${_emailController.text}","password":"${_passController.text}"}';
      var response= await http.post("https://api.changecharity.io/users/signup", body:content).timeout(Duration(seconds: 7));

      print(response.body);

      if(response.body=="rpc error: code = Unknown desc = email exists"){
        setState(() {
          _emailErr="Email Taken";
          loading=!loading;
        });
        return;
      } else if(response.body.startsWith("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9")){
        _saveSignUp(response.body);
        _setTime();
        print("successful");
      }
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

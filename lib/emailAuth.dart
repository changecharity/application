import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './paintings.dart';

class EmailAuth extends StatefulWidget{
  @override
  _EmailAuthState createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth> with SingleTickerProviderStateMixin{

  AnimationController _controller;
  Animation<Offset> _paintAn;
  Animation<Offset> _bodyAn;
  final _pinController = TextEditingController();
  String token;

  void initState(){
    super.initState();

    _controller=AnimationController(vsync:this, duration:Duration(seconds:2));

    _paintAn = Tween<Offset>(
      begin:Offset(-1.0,-1.0),
      end:Offset(0,0)
    ).animate(CurvedAnimation(
      curve:Curves.fastLinearToSlowEaseIn,
      parent:_controller
    ));

    _bodyAn = Tween<Offset>(
        begin:Offset(1,2),
        end:Offset(0,0)
    ).animate(CurvedAnimation(
        curve:Curves.fastLinearToSlowEaseIn,
        parent:_controller
    ));

    _controller.forward();

    _getToken();
  }

  Widget _emailIcon(){
    return Container(
      child:Icon(
        Icons.email,
        size:100,
        color:Color.fromRGBO(0, 174, 229, 1),
      )
    );
  }

  Widget _verifyText(){
    return Container(
      margin:EdgeInsets.only(top:20),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text(
            'Verify Email',
            style:TextStyle(color:Colors.black, fontSize:24, fontWeight:FontWeight.bold),
          ),
          Container(
            margin:EdgeInsets.only(top:10),
            child:Text(
              'Please enter the 6 digit code sent to youremail@gmail.com',
              style:TextStyle(color:Colors.black, fontSize:14)
            )
          )
        ]
      )
    );
  }
  Widget _pinCode(){
    return Container(
      margin:EdgeInsets.only(top:10),
      width: MediaQuery.of(context).size.width*.75,
        child: PinCodeTextField(
          length: 6,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            //borderWidth:4,
           // borderRadius: BorderRadius.circular(5),
            inactiveColor: Colors.grey,
            activeColor:Colors.grey,
            selectedColor: Color.fromRGBO(0, 174, 229, 1),
            fieldHeight: 50,
            fieldWidth: 40,
          ),
          animationType: AnimationType.scale,
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          textStyle:TextStyle(color:Color.fromRGBO(0,174,229,1), fontSize:30),
          textInputType: TextInputType.number,
          controller: _pinController,
          //autoFocus: true,
          //errorAnimationController: errorController,
          //controller: textEditingController,
      )
    );
  }
  Widget _resend(){
   return Container(
        margin:EdgeInsets.only(top:10),
        child: Text(
            'Resend Code',
            style:TextStyle(color:Theme.of(context).primaryColor, fontSize:12)
        )
    );
  }

  Widget _verify(){
    return Padding(
      padding:EdgeInsets.only(top:30, right:MediaQuery.of(context).size.width*.075, bottom:20),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Verify',
              style: TextStyle(
                fontSize: 35,
              ),
            ),
          ),
          Container(
            child: RaisedButton(
              onPressed: () {
                _verifyAccount();
              },
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              elevation: 10,
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
          ),
        ],
      ),
    );
  }

  Widget _mainBodyContainer(){
    return Container(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*.2),
              width:MediaQuery.of(context).size.width*.85,
              padding:EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width*.07,
                  40,
                  MediaQuery.of(context).size.width*.07,
                  50
              ),
              decoration:BoxDecoration(
                  color:Colors.grey[100],
                  borderRadius:BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color:Colors.grey, offset:Offset.fromDirection(.9),blurRadius:10)]
              ),
              child:Column(
                  children:[
                    _emailIcon(),
                    _verifyText(),
                    _pinCode(),
                    _resend()
                  ]
              )
          ),
          _verify(),
        ],
      )
    );
  }

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Scaffold(
        body: SafeArea(
          child:SlideTransition(
            position:_paintAn,
            child:CustomPaint(
              painter:HomePaint(),
                  child: SlideTransition(
                      position:_bodyAn,
                      child: SingleChildScrollView(
                        child:_mainBodyContainer()
                      )
                  )
              )
          )
        ),
        //resizeToAvoidBottomPadding: false,
        //resizeToAvoidBottomInset: false,
      );
    }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _getToken() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    setState(() {
      token=prefs.getString('token');
    });
    //get token, if null,  pushReplacement sign out with message.
  }

  _verifyAccount() async{

    var content='{"user_token":"$token","key":"${_pinController.text}"}';
    var response= await http.post("https://changecharity.io/api/users/updatesignup", body:content);
    print (response.body);
    //check or success or error
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import './paintings.dart';
import './homePage.dart';

class EmailAuth extends StatefulWidget{

  final emailAddress;
  EmailAuth(this.emailAddress);
  
  @override
  _EmailAuthState createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth> with TickerProviderStateMixin{

  AnimationController _controller;
  AnimationController _loadingController;
  Animation<Offset> _paintAn;
  Animation<Offset> _bodyAn;
  Animation<Color> _loadingAn;
  final _pinController = TextEditingController();
  final focusNode=FocusNode();
  String token;
  String _pinError='';
  String resendText="Resend Code";
  bool canResend=true;
  bool missingChar=false;
  bool loading=false;
  bool resendLoading = false;


  void initState(){
    super.initState();

    _controller=AnimationController(vsync:this, duration:Duration(seconds:2));
    _loadingController=AnimationController(vsync:this, duration:Duration(seconds:1));

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
    _loadingAn = _loadingController.drive(
        ColorTween(begin: Colors.lightBlue[200], end: Colors.lightBlue[600]));


    _controller.forward();
    _loadingController.repeat();

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
              'Please enter the 6 digit code sent to ${widget.emailAddress}',
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
          onSubmitted:(s){
            if(_pinController.text.length<6){
              setState(() {
                missingChar=!missingChar;
                print('missing chars');
              });
            }
          },
          onChanged:(s){
            setState(() {
              _pinError='';
            });
          },
          length: 6,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            //borderWidth:4,
           // borderRadius: BorderRadius.circular(5),
            inactiveColor: !missingChar ? Colors.grey : Colors.red,
            activeColor:Color.fromRGBO(0, 174, 229, 1),
            selectedColor: !missingChar?Colors.grey:Colors.red,
            fieldHeight: 50,
            fieldWidth: 40,
          ),
          animationType: AnimationType.scale,
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          textStyle:TextStyle(color:Color.fromRGBO(0,174,229,1), fontSize:30),
          textInputType: TextInputType.number,
          controller: _pinController,
          focusNode: focusNode,

      )
    );
  }
  Widget _resendCont(){
   return Container(
        margin:EdgeInsets.only(top:10),
        child:_resendContent()
    );
  }

  Widget _resendContent(){
    if(canResend){
      return GestureDetector(
          onTap:(){
            _resend();
          },
          child:Text(
              resendText,
              style:TextStyle(color:Color.fromRGBO(0, 174, 229, 1), fontSize:12)
          )
      );
    }
    return Container(
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          _resendTxt(),
          _resendLoadInd()
        ]
      )
    );
  }

  Widget _resendTxt(){
    return Text(
        resendText,
        style:TextStyle(color:Color.fromRGBO(0, 174, 229, 1), fontSize:12)
    );
  }

  Widget _resendLoadInd(){
    if(resendLoading){
      return Container(
        margin:EdgeInsets.only(left:18),
        child:SizedBox(
          width:12,
          height:12,
            child:CircularProgressIndicator(
                strokeWidth:2,
                valueColor: _loadingAn
            )
        )
      );
    }
    return Container();
  }

  Widget _errorCont(){
    return Container(
      child: Text(
        _pinError,
        style:TextStyle(color:Colors.red)
      ),
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
          _verifyButton()
        ],
      ),
    );
  }

  Widget _verifyButton(){
    if(loading){
      return Container(
          margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
          child:CircularProgressIndicator(
            valueColor:_loadingAn,
          )
      );
    }
    return Container(
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
                    _errorCont(),
                    _resendCont()
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
      return Material(
        child:GestureDetector(
          onTap:(){
            focusNode.unfocus();
          },
          child: SafeArea(
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
        )
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

  _resend() async{
    setState((){
      canResend=!canResend;
      resendText="Sending";
      resendLoading=!resendLoading;
    });

    var content='{"user_token":"$token"}';
    var response = await http.post("https://changecharity.io/api/users/resendemailkey", body:content);

    print(response.body);
    if(response.body=="rpc error: code = Unknown desc = unknown token"){
      setState(() {
        resendLoading=!resendLoading;
        //bring back to sign up page
        _pinError="Invalid user. Please sign up";
      });
    }else if(response.body=="success:true"){
      setState(() {
        resendLoading=!resendLoading;
        resendText="Sent";
      });
      Future<void>.delayed(Duration(seconds:3),(){
        setState(() {
          canResend=!canResend;
          resendText="Resend Code";
        });
      });
    }
  }

  _verificationSuccessful() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>HomePage()));
  }

  _verifyAccount() async{
    setState((){
      loading=!loading;
    });
    var content='{"user_token":"$token","key":"${_pinController.text}"}';
    var response= await http.post("https://changecharity.io/api/users/updatesignup", body:content);
    print (response.body);


    if(response.body=="rpc error: code = Unknown desc = key is incorrect"||response.body=="proto: (line 1:171): invalid value for int32 type: "){
        setState(() {
          loading=!loading;
          _pinError = "Code is incorrect. Please try again.";
          return;
        });
    }else if(response.body=="success"){
      _verificationSuccessful();
    }

  }
}
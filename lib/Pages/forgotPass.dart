import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../paintings.dart';

class ForgotPass extends StatefulWidget{

  final int pin;
  ForgotPass(this.pin);

  @override
  _ForgotPassState createState()=>_ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass>{

  final _emailController=TextEditingController();
  var _passErr='';
  final _passController=TextEditingController();
  final  _confirmController= TextEditingController();
  var obscurePass=true;
  var obscurePass2=true;
  final passFocusNode=new FocusNode();
  final confirmFocusNode=new FocusNode();



  Widget _passIcon(){
    return Container(
        alignment: Alignment.center,
        child:Icon(
          Icons.lock,
          size:100,
          color:Color.fromRGBO(0, 174, 229, 1),
        )
    );
  }

  Widget _forgotPassText(){
    return Container(
        margin:EdgeInsets.only(top:20),
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text(
                'Reset Password',
                style:TextStyle(color:Colors.black, fontSize:28, fontWeight:FontWeight.bold),
              ),
              Container(
                  margin:EdgeInsets.only(top:10),
                  child:Text(
                      'Please enter your new password',
                      style:TextStyle(color:Colors.black, fontSize:16)
                  )
              )
            ]
        )
    );
  }

  Widget _passInput() {
    return Container(
      margin: EdgeInsets.only(top:30),
      width:MediaQuery.of(context).size.width*.75,
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
          passFocusNode.nextFocus();
        },
        decoration: InputDecoration(
          labelText: "Password",
          hasFloatingPlaceholder: false,
          prefixIcon: _passPrefix(),
          suffixIcon: _passSuffix(),
        ),
        focusNode: passFocusNode,
      ),
    );
  }

  Widget _confirmPassInput() {
    return Container(
      //padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      margin: EdgeInsets.only(top:30),
      width:MediaQuery.of(context).size.width*.75,
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
        controller:_confirmController,
        obscureText: obscurePass2,
        onChanged: (s){
          setState(() {
            _passErr='';
          });
        },
        onEditingComplete: (){
          FocusScope.of(context).nextFocus();
        },
        decoration: InputDecoration(
          labelText: "Confirm Password",
          hasFloatingPlaceholder: false,
          prefixIcon: _passPrefix(),
          suffixIcon: _passSuffix2(),
        ),
        focusNode: confirmFocusNode,
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
      margin: EdgeInsets.only(right: 25),
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
  Widget _passSuffix2() {
    return Container(
      margin: EdgeInsets.only(right: 25),
      child: IconButton(
          onPressed:(){
            setState(() {
              obscurePass2=!obscurePass2;
            });
          },
          icon:Icon(
            obscurePass2?Icons.visibility:Icons.visibility_off,
            size: 20,
            color: Colors.black,
          )
      ),
    );
  }

  Widget _errorCont(){
    return Container(
      child: Text(
          _passErr,
          style:TextStyle(color:Colors.red)
      ),
    );
  }


  Widget _mainBodyContainer(){
    return Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child:Column(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      _passIcon(),
                      _forgotPassText(),
                      _passInput(),
                      _confirmPassInput(),
                      _errorCont(),
                    ]
                )
            ),
            //_resetButton(),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child:GestureDetector(
        onTap:(){
          FocusScope.of(context).unfocus();
        },
          child:SafeArea(
              child:CustomPaint(
                  painter: HomePaint(),
                  child: SingleChildScrollView(
                      child:_mainBodyContainer()
                  )
              )
          )
      )

    );
  }

}
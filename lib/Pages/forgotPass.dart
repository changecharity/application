import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import '../paintings.dart';
import 'login.dart';

class ForgotPass extends StatefulWidget{

  final int pin;
  ForgotPass(this.pin);

  @override
  _ForgotPassState createState()=>_ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> with TickerProviderStateMixin{

  String _passErr="";
  String token;
  final _passController=TextEditingController();
  final  _confirmController= TextEditingController();
  bool obscurePass=true;
  bool obscurePass2=true;
  bool loading=false;
  final passFocusNode=FocusNode();
  final confirmFocusNode=FocusNode();

  AnimationController _loadingController;
  Animation<Color> _loadingAn;

  void initState(){
    super.initState();

    _getToken();
    _loadingController=AnimationController(vsync:this, duration:Duration(seconds:1));
    _loadingAn=_loadingController.drive(
      ColorTween(begin:Colors.lightBlue[200], end:Colors.lightBlue[600])
    );
    _loadingController.repeat();

  }

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
        onSubmitted: (s){
          setState(() {
            FocusScope.of(context).requestFocus(confirmFocusNode);
          });
        },
        decoration: InputDecoration(
          labelText: "Password",
          hasFloatingPlaceholder: false,
          prefixIcon: _passPrefix(),
          suffixIcon: _passSuffix(),
        ),
        focusNode: passFocusNode,
        textInputAction: TextInputAction.next,
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
          FocusScope.of(context).unfocus();
          _resetPass();
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
      margin:EdgeInsets.only(top:10),
      child: Text(
          _passErr,
          textAlign:TextAlign.center,
          style:TextStyle(color:Colors.red)
      ),
    );
  }

  Widget _reset(){
    return Padding(
      padding:EdgeInsets.only(top:30, right:MediaQuery.of(context).size.width*.075, bottom:20),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Reset',
              style: TextStyle(
                fontSize: 35,
              ),
            ),
          ),
          _resetButton()
        ],
      ),
    );
  }

  Widget _resetButton(){
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
          FocusScope.of(context).unfocus();
          _resetPass();
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
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child:Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).viewInsets.bottom == 0
                  ? MediaQuery.of(context).size.height>700 ? MediaQuery.of(context).size.height*.2 :MediaQuery.of(context).size.height *0.15
                  : MediaQuery.of(context).size.height*.05),
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
            _reset(),
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

  void dispose(){
    _loadingController.dispose();
    super.dispose();
  }

  _getToken() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    setState(() {
      token=prefs.getString('token');
      print(token);
      if (token==null ||token==""){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
      }
    });

  }
  bool _validPass(){
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
    } else if(_confirmController.text==''||_confirmController.text==null){
      setState((){
        _passErr="Please confirm password";
      });
    }
    return true;
  }

  bool _matchingPass(){
    if(_confirmController.text!=_passController.text){
      setState(() {
        _passErr="Passwords do not match";
      });
      return false;
    }
    return true;
  }

  void _resetPass() async{

    if(!_validPass() || !_matchingPass()){
      setState(() {
        return;
      });
    } else {
      setState(() {
        loading=!loading;
      });


      var content='{"user_token":"$token", "password":"${_passController.text}", "key":${widget.pin}}';
      var response = await http.post("https://api.changecharity.io/users/forgotpass", body:content);
      print(response.body);
      if(response.body.contains("success")){
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Login()));
      }

    }
  }

}
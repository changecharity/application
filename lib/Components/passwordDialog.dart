import 'dart:async';
import 'dart:convert';
import'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'unlinkAccountDialog.dart';
import 'changeAccountDialog.dart';


class PasswordDialog extends StatefulWidget {
  @override
  _PwDialogState createState() => _PwDialogState();

  final String action;

  PasswordDialog(this.action);
}

class _PwDialogState extends State<PasswordDialog> with SingleTickerProviderStateMixin{

  Animation<Color> loadingAn;
  AnimationController loadingController;

  var token;
  String _passErr=" ";
  var _passController=TextEditingController();
  bool obscurePass=true;
  bool loading=false;


  void initState(){
    super.initState();

    loadingController= AnimationController(
        vsync: this, duration: Duration(seconds: 1));
    loadingAn = loadingController.drive(
        ColorTween(begin: Colors.lightBlue[200], end: Colors.lightBlue[600]));

    loadingController.repeat();
  }

  Widget _confirmText(){
    return Column(
      children: <Widget>[
        Text(
            'Password Confirmation',
            style:TextStyle(
                fontSize: 24,
                fontWeight:FontWeight.bold
            )
        ),
        Container(
          margin: EdgeInsets.only(top:10),
          child:Text(
              'Please confirm your password to continue:',
              style:TextStyle(
                fontSize: 14,
              )
          ),
        ),
      ],
    );
  }

  Widget _passwordContainer(){
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(right: 10, left: 10, top:45),
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
            child: TextField(
              controller:_passController,
              obscureText: obscurePass,
              onChanged: (s){
                setState(() {
                  _passErr=' ';
                });
              },
              onEditingComplete: (){
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                labelText: "Password",
                hasFloatingPlaceholder: false,
                prefixIcon: _passPrefix(),
                suffixIcon: _passSuffix(),
              ),
            )
        ),
        _passErr==null||_passErr==''?Container():_errorContainer(),
      ],
    );
  }

  Widget _passPrefix() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
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
      margin: EdgeInsets.only(left: 15, right: 15),
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
          _passErr,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  Widget _confirmCont(context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Confirm',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          _confirmButton(context)
        ],
      ),
    );
  }

  Widget _confirmButton(context){
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
          _validPassAndAction(widget.action);

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
              //height:MediaQuery.of(context).size.height*.4,
              padding:EdgeInsets.symmetric(vertical:20, horizontal:10),
              child:Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _confirmText(),
                  _passwordContainer(),
                  _confirmCont(context)
                ],
              )
          )
      )
    );
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  _validPassAndAction(String action) async{
    setState(() {
      loading=!loading;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(token);
    var content='{"user_token":"$token", "password":"${_passController.text}"}';
    var response=await http.post("https://api.changecharity.io/users/validpass", body:content);
    print(response.body);

    if(response.body=="rpc error: code = Unknown desc = Wrong Password") {
      setState(() {
        loading = !loading;
        _passErr = "Wrong Password";
      });
      return;
    }else if(response.body=="success"){
      Navigator.of(context).pop();
      if(action=="unlink"){
        showDialog(context:context, builder:(context)=>UnlinkDialog(_passController.text), barrierDismissible: true);
      } else if(action=="change"){
        showDialog(context:context, builder:(context)=>ChangeAccDialog(_passController.text), barrierDismissible: true);
      }
    }
  }


}



import'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/unlinkAccountDialog.dart';
import 'changeAccountDialog.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:change_charity_components/change_charity_components.dart';

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
  String _passErr="";
  var _passController=TextEditingController();
  bool obscurePass=true;
  bool loading=false;
  GlobalConfiguration cfg = new GlobalConfiguration();
  FocusNode _passwordFocus = FocusNode();

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
                fontSize: 20,
                fontWeight:FontWeight.bold
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(30,20,30,0),
          child:Text(
              'Please confirm your Change Charity account password to continue:',
              style:TextStyle(
                fontSize: 14,
              )
          ),
        ),
      ],
    );
  }

  Widget _passwordContainer() {
    return ChangeTextInput(
      controller: _passController,
      focusNode: _passwordFocus,
      prefixIcon: Icons.lock,
      isPassword: true,
      hintText: "Password",
      autofillHint: AutofillHints.password,
      last: true,
      lastFunc: _validPassAndAction,
      errMsg: _passErr,
      errFunc: (s){
        setState(() {
          _passErr = s;
        });
      },
    );
  }

  Widget _confirmCont() {
    return ChangeSubmitRow(
      animation: loadingAn,
      onClick: _validPassAndAction,
      loading: loading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() {
        FocusScope.of(context).unfocus();
      },
      child:Dialog(
        backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light ?  Colors.grey[100] : Colors.grey[900],
        elevation:15,
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
        child:Container(
          padding:EdgeInsets.symmetric(vertical:20, horizontal:10),
          child:Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _confirmText(),
              Container(height: 50,),
              _passwordContainer(),
              _confirmCont()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  void _validPassAndAction() async{
    if(_passController.text == "" || _passController.text == null) {
      setState(() {
        _passErr = "Can't be empty";
      });
      return;
    }

    setState(() {
      loading=!loading;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(token);
    var content='{"user_token":"$token", "password":"${_passController.text}"}';
    var response=await http.post("${cfg.getString("host")}/users/validpass", body:content);
    print(response.body);
    setState(() {
      loading = !loading;
    });
    if(response.body=="rpc error: code = Unknown desc = Wrong Password") {
      setState(() {
        _passErr = "Wrong Password";
      });
      return;
    }else if(response.body=="success"){
      Navigator.of(context).pop();
      if(widget.action=="unlink"){
        showDialog(context:context, builder:(context)=>UnlinkDialog(_passController.text), barrierDismissible: true);
      } else if(widget.action=="change"){
        showDialog(context:context, builder:(context)=>ChangeAccDialog(password: _passController.text, action: "update",), barrierDismissible: true);
      }
    }
  }
}



import 'package:change_charity_components/change_charity_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Pages/emailAuth.dart';
import 'package:global_configuration/global_configuration.dart';

class EnterEmail extends StatefulWidget{
  _EnterEmailState createState()=> _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> with TickerProviderStateMixin{
  Animation<Color> loadingAn;
  AnimationController loadingController;
  FocusNode _emailFocus = FocusNode();

  String _emailErr="";
  var _emailController=TextEditingController();
  bool loading=false;
  GlobalConfiguration cfg = new GlobalConfiguration();

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
            'Forgot Password?',
            style:TextStyle(
                fontSize: 20,
                fontWeight:FontWeight.bold
            )
        ),
        Container(
          margin: EdgeInsets.only(top:20,left: 20,right: 20, bottom: 50),
          child:Text(
              'Please enter your email address to continue:',
              style:TextStyle(
                fontSize: 14,
              )
          ),
        ),
      ],
    );
  }

  Widget _emailContainer() {
    return ChangeTextInput(
      controller: _emailController,
      focusNode: _emailFocus,
      errMsg: _emailErr,
      hintText: "Email",
      prefixIcon: Icons.mail,
      last: true,
      lastFunc: _submitEmail,
      errFunc: (s){
        setState(() {
          _emailErr = s;
        });
      },
    );
  }


  Widget _submitCont() {
    return ChangeSubmitRow(
      loading: loading,
      animation: loadingAn,
      onClick: _submitEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap:() {
          FocusScope.of(context).unfocus();
        },
        child:Dialog(
          backgroundColor: Colors.grey[100],
          elevation:15,
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
          child:Container(
//                height:MediaQuery.of(context).size.height*.5,
            padding:EdgeInsets.symmetric(vertical:20, horizontal:10),
            child:Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _confirmText(),
                _emailContainer(),
                _submitCont(),
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

  void _setTime()async{
    var timePlusThirty=DateTime.now().add(new Duration(seconds:1800));
    SharedPreferences timePref =await SharedPreferences.getInstance();
    timePref.setString('time', timePlusThirty.toString());
    print(timePlusThirty.toString());
  }

  _submitEmail() async{
    if (_emailController.value.text == "") {
      setState(() {
        _emailErr = 'Please enter your email';
      });
      return;
    }

    setState(() {
      loading=!loading;
    });

    var content='{"email":"${_emailController.text}"}';
    var response=await http.post("${cfg.getString("host")}/users/sendforgotpass", body:content);
    print(response.body);

    if(response.body=="rpc error: code = Unknown desc = email does not exist") {
      setState(() {
        loading = !loading;
        _emailErr = "No account associated with this email";
      });
      return;
    }else {
      SharedPreferences prefs= await SharedPreferences.getInstance();
      prefs.setString('token',response.body);
      prefs.setString('forgotPassEmail', "${_emailController.text}");
      if(prefs.getString('token')!=null&&prefs.getString('token')!=''){
        _setTime();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=>EmailAuth(_emailController.text, "forgotpass")), (route) => false);
      }
    }
  }
}
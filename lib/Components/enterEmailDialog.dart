import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Pages/emailAuth.dart';

class EnterEmail extends StatefulWidget{
  _EnterEmailState createState()=> _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> with TickerProviderStateMixin{
  Animation<Color> loadingAn;
  AnimationController loadingController;

  String _emailErr="";
  var _emailController=TextEditingController();
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
            'Forgot Password?',
            style:TextStyle(
                fontSize: 24,
                fontWeight:FontWeight.bold
            )
        ),
        Container(
          margin: EdgeInsets.only(top:10),
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

  Widget _emailContainer(){
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(right: 10, left: 10),
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
              controller:_emailController,
              onChanged: (s){
                setState(() {
                  _emailErr='';
                });
              },
              onEditingComplete: (){
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                labelText: "Email",
                hasFloatingPlaceholder: false,
                prefixIcon: _emailIcon(),
              ),
            )
        ),
        _emailErr==null||_emailErr==''?Container():_errorContainer(),
      ],
    );
  }

  Widget _emailIcon() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Icon(
        Icons.email,
        size: 20,
        color: Colors.black,
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
          _emailErr,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  Widget _submitCont(context) {
    return Container(
      margin: EdgeInsets.only(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Submit',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          _submitButton(context)
        ],
      ),
    );
  }

  Widget _submitButton(context){
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
          _submitEmail();
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
              borderRadius: BorderRadius.all(Radius.circular(60))),
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
    return GestureDetector(
        onTap:() {
          FocusScope.of(context).unfocus();
        },
        child:Dialog(
            backgroundColor: Colors.grey[100],
            elevation:15,
            shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
            child:Container(
                height:MediaQuery.of(context).size.height*.4,
                padding:EdgeInsets.symmetric(vertical:20, horizontal:10),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _confirmText(),
                    _emailContainer(),
                    _submitCont(context)
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

  _submitEmail() async{
    setState(() {
      loading=!loading;
    });

    var content='{"email":"${_emailController.text}"}';
    var response=await http.post("https://api.changecharity.io/users/sendforgotpass", body:content);
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
      if(prefs.getString('token')!=null&&prefs.getString('token')!=''){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=>EmailAuth(_emailController.text, "forgotpass")), (route) => false);
      }
    }
  }
}
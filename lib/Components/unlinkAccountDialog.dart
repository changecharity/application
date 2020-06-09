import'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:change/Pages/profile.dart';
import 'package:change/Pages/profile.dart';

class UnlinkDialog extends StatefulWidget {
  @override
  _UnlinkDialogState createState() => _UnlinkDialogState();

  final String password;
  UnlinkDialog(this.password);

}

class _UnlinkDialogState extends State<UnlinkDialog>{

  var token;

  Widget _unlinkText(){
    return Text(
      'Are you sure you want to unlink your bank account?',
      style:TextStyle(
        fontSize:20
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _unlinkButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:[
        _optionButton("No"),
        _optionButton("Yes")
      ]
    );
  }

  Widget _optionButton(String option){
    return Container(
      child: RaisedButton(
        onPressed: (){
          if(option=="No"){
            Navigator.of(context).pop();
          }else if(option=="Yes"){
            _unlinkAccount();
          }
        },
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(60))),
        child: Ink(
          width: 86,
          height: 40,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue[400], Colors.lightBlue[300]],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Center(
            child:Text(
                option,
                textAlign: TextAlign.center,
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                )
            )
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
                height:MediaQuery.of(context).size.height*.3,
                padding:EdgeInsets.symmetric(vertical:30, horizontal:20),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _unlinkText(),
                    _unlinkButtons(),
                  ],
                )
            )
        )
    );
  }

  _unlinkAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(token);

    var content = '{"user_token":"$token", "password":"${widget.password}"}';
    var response = await http.post(
        "https://api.changecharity.io/users/deletebankacc", body: content);

    print(response.body);
    if (response.body == "success") {
      Navigator. pop(context, () {
        setState(() {
        });
      });
    }
  }

}

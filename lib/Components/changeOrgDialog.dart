import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Models/userOrgModel.dart';
import '../Pages/profile.dart';


class ChangeOrgDialog extends StatefulWidget{
  @override
  _ChangeOrgDialogState createState()=>_ChangeOrgDialogState();

  final int id;
  ChangeOrgDialog(this.id);

}

class _ChangeOrgDialogState extends State<ChangeOrgDialog> with TickerProviderStateMixin{

  var token;
  var name="";
  var logo="https://wallpaperplay.com/walls/full/b/d/1/58065.jpg";
  var description="";


  void initState(){
    super.initState();
    _getOrgInfo();
    
  }

  Widget _selectText(){
    return Text(
      'Select Organization?',
      style:TextStyle(
          fontSize:24,
          fontWeight:FontWeight.bold
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _orgInfo(){
    return Container(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _orgLogo(),
          _orgName(),
          _orgDescription()
        ],
      )
    );
  }
  Widget _orgLogo(){
    return CircleAvatar(
      backgroundImage: NetworkImage("$logo"),
      radius:40
    );
  }

  Widget _orgName(){
    return Container(
      margin:EdgeInsets.only(top:10, bottom:10),
      child:Text(
          '$name',
          style: TextStyle(fontWeight:FontWeight.bold, color:Color.fromRGBO(0, 174, 229, 1), fontSize: 18)
      )
    );
  }

  Widget _orgDescription(){
    return Text(
      '$description',
      textAlign:TextAlign.center,

    );
  }


  Widget _selectOrgButtons(){
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
            _setOrg();
          }
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
                height:MediaQuery.of(context).size.height*.5,
                padding:EdgeInsets.symmetric(vertical:20, horizontal:10),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _selectText(),
                    _orgInfo(),
                    _selectOrgButtons()
                  ],
                )
            )
        )
    );
}


  void _getOrgInfo() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    token=prefs.getString('token');
    var content='{"user_token":"$token", "org":${widget.id}}';
    var response=await http.post("https://api.changecharity.io/users/getorginfo", body:content);
    print(response.body);
    setState(() {
      logo=jsonDecode(response.body)["logo"];
      name=jsonDecode(response.body)["name"];
      description=jsonDecode(response.body)["description"];
    });


  }

  //set the org and notify provider of the new org to show in profile
  void _setOrg() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    token=prefs.getString('token');
    var content = '{"user_token":"$token", "org":${widget.id}}';
    var response = await http.post("https://api.changecharity.io/users/setorg", body:content);
    print(response.body);
    context.read<UserOrgModel>().notify(name, logo);
    var count=0;
    Navigator.popUntil(context,(route)=>count++==2);
  }
}
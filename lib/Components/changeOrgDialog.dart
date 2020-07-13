import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Models/userOrgModel.dart';


class ChangeOrgDialog extends StatefulWidget{
  @override
  _ChangeOrgDialogState createState()=>_ChangeOrgDialogState();

  final int id;
  ChangeOrgDialog(this.id);

}

class _ChangeOrgDialogState extends State<ChangeOrgDialog>{

  var token;
  var name;
  var logo;
  var description;


  Widget _orgLogo(){
    return CircleAvatar(
      backgroundImage: NetworkImage("$logo"),
      radius:30
    );
  }

  Widget _orgName(){
    return Text(
      '$name',
      style: TextStyle(fontWeight:FontWeight.bold, color:Colors.black, fontSize: 24)
    );
  }

  Widget _orgDescription(){
    return Text(
      'About: $description'
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
                height:MediaQuery.of(context).size.height*.4,
                padding:EdgeInsets.symmetric(vertical:20, horizontal:10),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _orgLogo(),
                    _orgName(),
                    _orgDescription(),
                    //_donateButton(),
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
  }





}
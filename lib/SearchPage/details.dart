import "dart:convert";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Pages/homePage.dart';
import '../Models/userOrgModel.dart';

class DetailScreen extends StatefulWidget {

  @override
  _DetailState createState() => _DetailState();

  final tag;
  final id;
  final context;

  DetailScreen(this.tag, this.id, this.context);
}

class _DetailState extends State<DetailScreen>{
  var token;
  var logo="https://wallpaperplay.com/walls/full/b/d/1/58065.jpg";
  var name="";
  var slogan="insert slogan here";

  void initState(){
    super.initState();

    _getOrgInfo();

  }

  Widget _backButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10),
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        iconSize: 30,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _orgLogoHero(){
    return Container(
      width:MediaQuery.of(context).size.width*.3,
      child:AspectRatio(
        aspectRatio: 1/1,
        child:Hero(
          tag: widget.tag,
          child:Card(
            elevation:5,
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)
            ),
            child:ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child:Container(
                decoration:BoxDecoration(
                  image: DecorationImage(
                    image:NetworkImage("$logo"),
                    fit:BoxFit.cover
                  ),
                )
              )
            )
          )
        )
      )
    );
  }

  Widget _orgName(){
    return Container(
      margin:EdgeInsets.only(top:10),
      //color:Colors.grey,
      child:Text(
        '$name',
        style:TextStyle(
          fontFamily:'Montserrat',
          fontSize:24,
          fontWeight:FontWeight.bold,
          color:Colors.black,

        )
      )
    );
  }

  Widget _donateButton(BuildContext context){
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(0, 174, 229,1),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(color:Colors.grey, offset:Offset(2.5,2.5), blurRadius:5.0)]
        ),
        child: IconButton(
          padding:EdgeInsets.all(18),
          color: Colors.white,
          icon: Icon(Icons.attach_money),
          iconSize:25,
          tooltip: 'Donate',
          onPressed: () {
            _setOrg();
            Navigator.pushAndRemoveUntil(context, PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage()), (route) => false);
          }
        )
      )
    );
  }

  Widget _detailsContainer(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height *.5,
      margin:EdgeInsets.only(top:60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),),
        color: Colors.grey[100],
        boxShadow: [BoxShadow(
          color: Colors.grey[350],
          blurRadius: 10.0,
          offset: Offset.fromDirection(5, 7),
        ),],
      ),
      child: _details()
    );
  }

  _details(){
    return Container(
      padding:EdgeInsets.fromLTRB(20, 30, 20, 30),
      child:Column(
        mainAxisAlignment:MainAxisAlignment.start,
        children: <Widget>[
          Text(
            '"$slogan"',
            overflow:TextOverflow.ellipsis,
            style:TextStyle(
              color:Colors.lightBlueAccent,
              fontSize:20,
              fontWeight:FontWeight.bold,
              fontStyle:FontStyle.italic
            )
          ),
          Container(
            margin:EdgeInsets.only(top:30),
            alignment: Alignment.centerLeft,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'About:',
                      style:TextStyle(
                        fontWeight:FontWeight.bold,
                        color:Colors.grey,
                        fontSize: 20,
                      )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*.22,
                      child: Text(
                          'The Jewish study network inspires people all across the bay area and is a fun place to visit...etc etc'
                      )
                    )
                  ],
                ),
                Container(
                  //padding:EdgeInsets.symmetric(horizontal:10),
                  width:MediaQuery.of(context).size.width*.6,
                  height:MediaQuery.of(context).size.height*.3,
                  child: ListWheelScrollView(
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal:10),
                        child:Container(
                          decoration:BoxDecoration(
                            color:Colors.grey[int.parse('${index+2}00')],
                            borderRadius: BorderRadius.circular(20),
                          )
                        )
                      );
                      }
                    ),
                    itemExtent:130,
                    diameterRatio: 1.5,
                  )
                )
              ],
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        //child:SingleChildScrollView(
           child:Container(
             height:MediaQuery.of(context).size.height,
             child:Column(
               mainAxisAlignment: MainAxisAlignment.end,
               children: <Widget>[
                 _backButton(),
                 _orgLogoHero(),
                 _orgName(),
                 _detailsContainer()
               ],
             )
           )
        //)
      ),
      extendBody: true,
      floatingActionButton:_donateButton(context)
    );
  }

  //get the org info
  void _getOrgInfo() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    token=prefs.getString('token');
    var content='{"user_token":"$token", "org":${widget.id}}';
    var response=await http.post("https://api.changecharity.io/users/getorginfo", body:content);
    print(response.body);
    setState(() {
      logo=jsonDecode(response.body)["logo"];
      name=jsonDecode(response.body)["name"];
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


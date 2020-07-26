import 'dart:async';
import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import '../paintings.dart';
import 'linkBank.dart';


class OrgSelected extends StatefulWidget{
  @override
  _OrgSelectedState createState()=>_OrgSelectedState();
}

class _OrgSelectedState extends State<OrgSelected> with TickerProviderStateMixin{

  AnimationController _controller;
  Animation<Offset> _topDown;
  Animation<Offset> _bottomUp;
  Animation<Offset>_leftToRight;
  Animation<Color> _animationC;
  AnimationController controllerC;

  GlobalConfiguration cfg = new GlobalConfiguration();

  String token;
  String name = "";
  String logo = "";
  int id;
  bool loading = false;

  void initState(){
    super.initState();

    _getOrg();

    _controller = AnimationController(vsync: this, duration: Duration(seconds:2));
    controllerC = AnimationController(
        vsync: this, duration: Duration(seconds: 1));


    _topDown = Tween<Offset>(
      begin: Offset(1.0, -2.0),
      end:Offset(0.0,0.0),
    ).animate(CurvedAnimation(
        parent:_controller,
        curve:Curves.fastLinearToSlowEaseIn
    )
    );

    _bottomUp = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end:Offset(0.0,0.0),
    ).animate(CurvedAnimation(
        parent:_controller,
        curve:Curves.fastLinearToSlowEaseIn
    )
    );

    _leftToRight = Tween<Offset>(
      begin:Offset(-1.0, 0.0),
      end:Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent:_controller,
      curve:Curves.fastLinearToSlowEaseIn,
    )
    );

    _animationC = controllerC.drive(
        ColorTween(begin: Colors.lightBlue[200], end: Colors.lightBlue[600]));
    controllerC.repeat();


    Future<void>.delayed(Duration(milliseconds:1000),(){
      _controller.forward();
    });

  }

  Widget _orgSelected() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.11, 0, 0),
        child: Text(
          'Organization Selected',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 45,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _orgLogo() {
    return Container(
      margin:EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.03),
      height:120,
      width:120,
      child: ClipOval(
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: logo,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _orgName() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.fromLTRB(40, MediaQuery.of(context).size.height * 0.1, 40, 0),
        child: Text(
          '$name',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _selectOrgCont() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height > 700 ? 70 : 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _continueText(),
            _continueButton(),
          ],
        ),
      ),
    );
  }

  Widget _continueText() {
    if(MediaQuery.of(context).size.height > 700) {
      return Container(
        margin: EdgeInsets.fromLTRB(10,10,10,0),
        child: Text(
          'Select',
          style: TextStyle(
            fontSize: 33,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _continueButton() {
    if (loading) {
      return Container(
        margin: EdgeInsets.fromLTRB(42, 0, 32, 0),
        child: CircularProgressIndicator(
          valueColor: _animationC,
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(0,10,20,0),
        child: RaisedButton(
          onPressed: () {
            _setOrg();
          },
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(60))),
          child: Ink(
            width: 90,
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
  }

  Widget _skipText() {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: MediaQuery.of(context).size.height < 650 ? 30: 30),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _chooseLater();
            },
            child: Container(
              child: Text(
                "I Will Choose One Later",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child:SlideTransition(
            position:_leftToRight,
            child:CustomPaint(
                painter: HomePaint(),
                child:Container(
                  height:MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child:Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      children: <Widget>[
                        SlideTransition(position:_topDown, child:_orgSelected()),
                        SlideTransition(position:_bottomUp, child:_orgName()),
                        SlideTransition(position:_bottomUp, child:_orgLogo()),
                        Expanded(child: Container(),),
                        SlideTransition(position:_bottomUp, child:_selectOrgCont()),
                        Expanded(child: Container(),),
                        SlideTransition(position:_bottomUp, child:_skipText()),
                      ]
                  ),
                )
            )
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _getOrg() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    int org = preferences.getInt('selOrg');
    var content = '{"user_token":"$token", "org": $org}';
    var response = await http.post(
        "${cfg.getString("host")}/users/getorginfo", body: content);
    print(response.body);
    setState(() {
      name = jsonDecode(response.body)["name"];
      logo = jsonDecode(response.body)["logo"];
      id = jsonDecode(response.body)["id"];
    });
  }

  void _setOrg() async{
    setState(() {
      loading = true;
    });
    SharedPreferences prefs=await SharedPreferences.getInstance();
    token=prefs.getString('token');
    var content = '{"user_token":"$token", "org":$id}';
    var response = await http.post("${cfg.getString("host")}/users/setorg", body:content);
    print(response.body);
    prefs.setInt('selOrg', null);
    setState(() {
      loading = false;
    });
    prefs.setString('linkBank', name);
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>LinkBank(name)));
  }

  void _chooseLater() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setInt('selOrg', null);
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>LinkBank("")));
  }

}
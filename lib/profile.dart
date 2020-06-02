//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SearchPage/search2.dart';
import 'paintings.dart';
import 'UserOrgModel.dart';
import 'homePage.dart';
import 'login.dart';



class Profile extends StatefulWidget{

  @override
  _ProfileState createState()=>_ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin{

  AnimationController _controller;
  Animation<Offset> _topDown;
  Animation<Offset> _bottomUp;
  Animation<Offset>_rightToLeft;

  String token;
  var maxChange=100.00;
  bool sliderChanging=false;
  var _widgetIndex=0;
  var profileLetter='';
  bool showMenu=false;



  void initState(){
    super.initState();

    _confirmLogin();
    _getProfileLetter();

    _controller = AnimationController(vsync: this, duration: Duration(seconds:2));

    _topDown = Tween<Offset>(
      begin: Offset(-1.0, -2.0),
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

    _rightToLeft = Tween<Offset>(
      begin:Offset(1.0, 0.0),
      end:Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent:_controller,
      curve:Curves.fastLinearToSlowEaseIn,
    )
    );
    _controller.forward();



  }

  Widget _backButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10),
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        color:Colors.black,
        iconSize: 30,
        onPressed: () {
          _controller.animateBack(0, duration:Duration(milliseconds:500), curve:Curves.linear);
          Future<void>.delayed(Duration(milliseconds:500),(){
            Navigator.push(context, MaterialPageRoute(builder:(context)=>HomePage()));
          });
        },
      ),
    );
  }

  Widget _menuIcon(){
    return Container(
      margin: EdgeInsets.only(top: 20, right: 10),
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: Icon(Icons.settings),
        color:Colors.black,
        iconSize: 30,
        onPressed: () {
          setState(() {
            showMenu=!showMenu;
          });
        },
      ),
    );
  }

  Widget _menuDialog(){
    return Container(
      height:MediaQuery.of(context).size.height*.15,
      width:MediaQuery.of(context).size.width*.55,
      padding:EdgeInsets.all(20),
      decoration: BoxDecoration(
          color:Colors.grey[100],
          borderRadius:BorderRadius.circular(10),
          border:Border.all(color:Colors.grey),
          //boxShadow: [BoxShadow(color:Colors.grey, offset:Offset(5,5), blurRadius:5)]
      ),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Sign Out'),
          Text('Change Password'),
          Text('Delete Account')
        ],
      )
    );

  }


  Widget _accountContainer(){
    return Container(
      width:MediaQuery.of(context).size.width*1,
      child:Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _backButton(),
              _menuIcon()
            ],
          ),
          Container(
            margin:EdgeInsets.only(bottom:10, top:40),
            height:80,
            width:80,
            decoration: BoxDecoration(
              color:Color.fromRGBO(0, 174, 229, 1),
              shape:BoxShape.circle,
            ),
            child: Align(
              alignment: Alignment.center,
              child:Text(
                profileLetter,
                style:TextStyle(
                  color:Colors.white,
                  fontSize:40,
                  fontWeight:FontWeight.bold
                )
              )
            )
          ),
          Text(
              'My Profile',
              style:TextStyle(color:Colors.black, fontSize:50)
          ),
        ],
      )
    );
  }

  Widget _accountPrefs(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin:EdgeInsets.only(bottom:10, left:10, top:15),
            child:Text(
                'Preferences',
                style: TextStyle(fontSize:16, color:Colors.grey)
            )
        ),
        Container(
            padding:EdgeInsets.fromLTRB(0, 15, 0, 15),
            width: MediaQuery.of(context).size.width * .75,
            //height:MediaQuery.of(context).size.height*.4,
            decoration:BoxDecoration(
                color:Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color:Colors.grey[300], offset:Offset.fromDirection(1), blurRadius:15)]
            ),
            child:Column(
              //mainAxisAlignment: MainAxisAlignment,
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _widgetIndex!=0?IconButton(
                        icon: Icon(Icons.arrow_back_ios, color:Colors.black, size:16),
                        highlightColor: Colors.transparent,
                        onPressed:(){
                          setState(() {
                            _widgetIndex--;
                          });
                        }
                    ):IconButton(icon:Icon(Icons.arrow_back_ios, size:16, color:Colors.transparent)),
                    Expanded(
                      child:IndexedStack(
                        index:_widgetIndex,
                        children:<Widget>[
                          Center(child:Text('Set Your Max', style:TextStyle(fontSize:16, fontWeight: FontWeight.bold))),
                          Center(child:Text('Current Organization', style:TextStyle(fontSize:16, fontWeight: FontWeight.bold))),
                          Center(child:Text('Your Bank Account', style:TextStyle(fontSize:16, fontWeight: FontWeight.bold)))
                        ]
                      )
                    ),
                    _widgetIndex!=2?IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        color:Colors.black,
                        iconSize: 16,
                        onPressed:(){
                          setState(() {
                            _widgetIndex++;
                          });
                        }
                    ):IconButton(icon:Icon(Icons.arrow_forward_ios, size:16, color:Colors.transparent)),
                  ],
                ),
                IndexedStack(
                  index:_widgetIndex,
                  children: <Widget>[
                    _sliderContent(),
                    _currentOrgContent(),
                    _bankContent()
                  ],
                ),
              ]
          )
        )
      ],
    );
  }

  Widget _bankContent(){
    return Container(
      alignment: Alignment.center,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:10),
            width:100,
            height:100,
            decoration:BoxDecoration(
                color:Color.fromRGBO(0,174,229,1),
                borderRadius: BorderRadius.circular(100)
            ),
            child: Center(
              child: Icon(
                Icons.attach_money,
                size: 100,
                color:Colors.white
              )
            )
          ),
          Container(
            margin: EdgeInsets.only(top:10, bottom:15),
            child:Text(
                'Chase Savings (...8859)',
                style:TextStyle(color:Color.fromRGBO(0, 174, 229, 1), fontSize:18, fontWeight: FontWeight.bold)
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:[
              Text(
                  'Change Account',
                  style:TextStyle(color:Colors.grey[700], fontSize:12)
              ),
              Text(
                'Unlink Account',
                style:TextStyle(color:Colors.grey[700], fontSize:12)
              )
            ]
          )
        ],
      )
    );

  }

  Widget _currentOrgContent(){
    return Container(
      alignment: Alignment.center,
      child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                _currentOrgImg(),
                Container(
                  margin:EdgeInsets.only(top:10,bottom:10),
                  child:_currentOrgText()
                )
              ],
            ),
            Container(
                child:RichText(
                    text:TextSpan(
                        style:TextStyle(
                          color:Colors.grey[700],
                          fontSize:12,
                          fontFamily: 'Montserrat',
                        ),
                        text:"Change Organization",
                        recognizer: TapGestureRecognizer()
                          ..onTap=(){
                            Navigator.push(context, MaterialPageRoute(builder:(context)=>Search2()));
                          }
                    )
                )
            )
          ]
      ),
    );
  }

  Widget _currentOrgText(){
    return Consumer<UserOrgModel>(
      builder:(context, userOrg, child){
        return Text(
          '${userOrg.getUserOrg}',
          style:TextStyle(
            color:Color.fromRGBO(0, 174, 229, 1),
            fontSize:18,
            fontWeight: FontWeight.bold
          )
        );
      }
    );
  }

  Widget _currentOrgImg(){
    return Consumer<UserOrgModel>(
      builder:(context, userOrg, child){
        return Container(
          margin:EdgeInsets.only(top:10),
          height:100,
          width:100,
          decoration: BoxDecoration(
            image:DecorationImage(
              image: NetworkImage('${userOrg.getOrgImg}'),
              fit: BoxFit.cover,
            ),
            shape:BoxShape.circle,
          ),
        );
      }
    );
  }

  Widget _sliderContent(){
    return Container(
      alignment:Alignment.center,
      child:Column(
        children: <Widget>[
          Container(
            margin:EdgeInsets.only(top:10,bottom:15),
            width:100,
            height:100,
            decoration:BoxDecoration(
              color:Color.fromRGBO(0,174,229,1),
              borderRadius: BorderRadius.circular(100)
            ),
            child:Center(
              child:Text(
              maxChange==100?"\$1":"${maxChange.toStringAsFixed(0)}\u{00A2}",
              style:TextStyle(
                color:Colors.white,
                fontSize:30,
                fontWeight:FontWeight.bold
              )
              )
            )
          ),
          Container(
            width:MediaQuery.of(context).size.width*.55,
            child:Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin:EdgeInsets.only(right:15),
                  child:Text(
                    '50\u{00A2}',
                    style: TextStyle(
                      color:Color.fromRGBO(0,174,229,1),
                      fontSize:16,
                      fontWeight:FontWeight.bold
                    )
                  ),
                ),
                Expanded(
                    child:SliderTheme(
                      data:SliderThemeData(
                        thumbColor: Color.fromRGBO(0,174,229,1),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                        thumbShape:RoundSliderThumbShape(enabledThumbRadius: 10),
                        trackHeight: sliderChanging?10:4,
                        activeTrackColor:Color.fromRGBO(0,174,229,1),
                        inactiveTrackColor:Color.fromRGBO(0,174,229,.3),
                        showValueIndicator:ShowValueIndicator.never,
                        activeTickMarkColor: Colors.transparent,
                        inactiveTickMarkColor: Colors.transparent,
                        disabledActiveTickMarkColor: Colors.black,
                        disabledInactiveTickMarkColor: Colors.black,
                      ),
                      child:Slider(
                        value: maxChange,
                        onChanged:(newMax){
                          setState(() {
                            maxChange=newMax;
                          });
                        },
                        onChangeStart:(s){
                          setState(() {
                            sliderChanging=!sliderChanging;
                          });
                        },
                        onChangeEnd:(s){
                          setState(() {
                            sliderChanging=!sliderChanging;
                          });
                        },
                        min:50,
                        max:100,
                        divisions:10,
                      ),
                    )
                ),
                Text(
                  '\$1',
                  style: TextStyle(
                      color:Color.fromRGBO(0,174,229,1),
                      fontSize:16,
                      fontWeight:FontWeight.bold
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child:SafeArea(
        child:SlideTransition(
          position:_rightToLeft,
          child:CustomPaint(
            painter: ProfilePaint(),
            child:Container(
              height:MediaQuery.of(context).size.height,
              padding:EdgeInsets.only(bottom:MediaQuery.of(context).size.height*.15),
              child:Stack(
                children: <Widget>[
                    Column(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SlideTransition(position:_topDown, child:_accountContainer()),
                        SlideTransition(position:_bottomUp, child:_accountPrefs()),
                      ]
                    ),
                    Positioned(
                      top:70,
                      right:20,
                      child:showMenu?_menuDialog():Container(color:Colors.transparent)
                    )
                  ],
                )
              )
            )
          ),
        ),
    );
  }

  //call at init state. confirms user is logged in
  _confirmLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
    print(token);
    if(token == null || token ==''){
      Navigator.push(context, MaterialPageRoute(builder:(context)=>Login()));
    }
  }

  //call at initstate. gets the first letter of email address stored in shared preferences
  _getProfileLetter() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileLetter = prefs.getString('emailAddress').substring(0,1).toUpperCase();
    });
  }

  //call at initState to get user's max threshhold
  _getThreshhold() async{

  }

  //call on end of slider change to set user's max threshhold
  _setThreshhold() async{

  }

}
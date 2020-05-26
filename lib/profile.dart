import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:avataaar_image/avataaar_image.dart';
import 'SearchPage/search2.dart';
import 'homePage.dart';
import 'paintings.dart';




class Profile extends StatefulWidget{

  @override
  _ProfileState createState()=>_ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin{

  AnimationController _controller;
  Animation<Offset> _topDown;
  Animation<Offset> _bottomUp;
  Animation<Offset>_rightToLeft;

  var maxChange=99.0;
  bool sliderChanging=false;
  var _widgetIndex=0;


  void initState(){
    super.initState();

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
      curve:Curves.fastLinearToSlowEaseIn
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

  Widget _accountContainer(){
    return Container(
      width:MediaQuery.of(context).size.width*1,
      height:MediaQuery.of(context).size.height*.35,
      decoration:BoxDecoration(
          color:Colors.grey[100],
          borderRadius: BorderRadius.vertical(bottom:Radius.circular(25)),
          boxShadow:[BoxShadow(color:Colors.grey, offset:Offset.fromDirection(-5,7), blurRadius:10)]
      ),
      child:Column(
        children: <Widget>[
          _backButton(),
          Container(
            margin:EdgeInsets.only(bottom:10, top:10),
            height:80,
            width:80,
            decoration: BoxDecoration(
              color:Color.fromRGBO(0, 174, 229, .2),
              shape:BoxShape.circle,
            ),
            child: Align(
              alignment: Alignment.center,
              child:Text(
                'B',
                style:TextStyle(
                  color:Color.fromRGBO(0, 174, 229, 1),
                  fontSize:40,
                  fontWeight:FontWeight.bold
                )
              )
            )
          ),
          Text(
              'My Profile',
              style:TextStyle(color:Colors.black, fontWeight:FontWeight.bold, fontSize:24)
          ),
        ],
      )
    );
  }

  Widget _accountInfo(){
    return Container(
      padding:EdgeInsets.symmetric(vertical:15, horizontal:0),
      margin:EdgeInsets.only(bottom:10, top:15),
      width: MediaQuery.of(context).size.width * .75,
      height:MediaQuery.of(context).size.height*.45,
      decoration:BoxDecoration(
      color:Colors.grey[100],
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color:Colors.grey[300], offset:Offset.fromDirection(1), blurRadius:15)]
      ),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _widgetIndex!=0?IconButton(
              icon: Icon(Icons.arrow_back_ios, color:Colors.black, size:16),
              onPressed:(){
                setState(() {
                  _widgetIndex--;
                });
              }
          ):IconButton(icon:Icon(Icons.arrow_back_ios, size:16, color:Colors.transparent)),
          IndexedStack(
            index:_widgetIndex,
            children: <Widget>[
              _sliderContent(),
              _currentOrgContent(),
              _bankContent()
            ],
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
      )
    );
  }
//  Widget _bankInfo(){
//    return Padding(
//      padding:EdgeInsets.only(bottom:20),
//      child:Container(
//        margin:EdgeInsets.only(top:30),
//        width:MediaQuery.of(context).size.width*.7,
//        decoration: BoxDecoration(
//            color:Colors.grey[100],
//            borderRadius: BorderRadius.circular(15),
//            boxShadow: [BoxShadow(color:Colors.grey, offset:Offset.fromDirection(.9), blurRadius:10)]
//        ),
//        child:Column(
//          children: <Widget>[
//            Container(
//              height:20,
//              width:MediaQuery.of(context).size.width*.7,
//              decoration: BoxDecoration(
//                color:Color.fromRGBO(0, 174, 229, 1).withOpacity(.5),
//                borderRadius: BorderRadius.vertical(top: Radius.circular(15))
//              ),
//            ),
//            Container(
//              padding:EdgeInsets.fromLTRB(10, 10, 0, 0),
//              alignment:Alignment.centerLeft,
//              child:Text(
//                'Linked Account',
//                style:TextStyle(color:Colors.black, fontSize:16, fontWeight: FontWeight.bold)
//              )
//            ),
//            Container(
//              padding:EdgeInsets.fromLTRB(0,0, 10, 10),
//              margin:EdgeInsets.only(top:40),
//              alignment:Alignment.bottomRight,
//              child:Column(
//                crossAxisAlignment: CrossAxisAlignment.end ,
//                children: <Widget>[
//                  Text(
//                    'Chase Savings (...8859)',
//                    style:TextStyle(color:Color.fromRGBO(0, 174, 229, 1), fontSize:18)
//                  ),
//                  Text(
//                    'Change Account',
//                    style:TextStyle(color:Colors.grey[700], fontSize:12)
//                  )
//                ],
//              )
//            )
//          ],
//        )
//      )
//    );
//  }

  Widget _bankContent(){
    return Padding(
      padding:EdgeInsets.only(bottom:20),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            alignment:Alignment.centerLeft,
            child:Text(
                'Your bank account',
                style:TextStyle(color:Colors.black, fontSize:16)
            )
          ),
          Container(
            alignment: Alignment.center,
            child:Text(
                'Chase Savings (...8859)',
                style:TextStyle(color:Color.fromRGBO(0, 174, 229, 1), fontSize:18, fontWeight: FontWeight.bold)
            ),
          ),
          Text(
              'Change Account',
              style:TextStyle(color:Colors.grey[700], fontSize:12)
          )
        ],
      )
    );

  }

  Widget _currentOrgContent(){
    return Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child:Text(
                  'Current organization',
                  style: TextStyle(color:Colors.black, fontSize:16)
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width:100,
                  height:100,
                  decoration: BoxDecoration(
                    color:Color.fromRGBO(0,174,229,1),
                    borderRadius: BorderRadius.circular(100)
                  ),
                ),
                Text(
                    'Partners in Torah',
                    style:TextStyle(
                        color:Color.fromRGBO(0, 174, 229, 1),
                        fontSize:18
                    )
                )
              ],
            ),
            Container(
              child:RichText(
                text:TextSpan(
                  style:TextStyle(
                    color:Colors.grey[700],
                    fontSize:12
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

  Widget _sliderContent(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Align(
          //alignment:Alignment.topLeft,
          child:Text(
            "Set Your Max",
            style:TextStyle(
              color:Colors.black,
              fontSize:16,
              //fontWeight:FontWeight.bold
            )
          )
        ),
        Container(
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
                color:Colors.black,
                fontSize:30,
                fontWeight:FontWeight.bold
              )
            )
          )
        ),
        Container(
          width:MediaQuery.of(context).size.width*.5,
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
    return Scaffold(
      body:SafeArea(
        child:SlideTransition(
          position:_rightToLeft,
          child:CustomPaint(
              painter: ProfilePaint(),
              child:Container(
                  height:MediaQuery.of(context).size.height,
                  padding:EdgeInsets.only(bottom:MediaQuery.of(context).size.height*.05),
                  child:Column(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SlideTransition(position:_topDown, child:_accountContainer()),
                      SlideTransition(position:_bottomUp, child:_accountInfo()),
                    ],
                  )
              )
          ),
        )
      ),
      extendBody: true,
    );
  }
}
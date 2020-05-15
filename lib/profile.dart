import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:avataaar_image/avataaar_image.dart';

import 'SearchPage/search2.dart';
import 'homePage.dart';




class Profile extends StatefulWidget{

  @override
  _ProfileState createState()=>_ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin{

  AnimationController _controller;
  Animation<Offset> _topDown;
  Animation<Offset> _bottomUp;

  var maxChange=.99;
  var _avatars = [
    Avataaar(
      skin:Skin.light,
      mouth:Mouth.twinkle,
      style:Style.circle,
      top:Top.shortHairShortFlat(hairColor: HairColor.Brown),
      eyes:Eyes.defaultEyes,
      clothes:Clothes.shirtCrewNeck(ClotheColor.White),
    ),
    Avataaar(
      skin:Skin.pale,
      mouth:Mouth.smile,
      style:Style.circle,
      top:Top.shortHairShortCurly(hairColor: HairColor.Blonde),
      eyes:Eyes.happy,
      clothes:Clothes.shirtCrewNeck(ClotheColor.White),
    ),
    Avataaar(
      skin:Skin.pale,
      mouth:Mouth.twinkle,
      style:Style.circle,
      top:Top.shortHairShortWaved(hairColor: HairColor.BrownDark, accessoriesType: AccessoriesType.Round),
      eyes:Eyes.squint,
      clothes:Clothes.shirtCrewNeck(ClotheColor.White),
    ),
    Avataaar(
      skin:Skin.pale,
      mouth:Mouth.smile,
      style:Style.circle,
      top:Top.shortHairShortRound(hairColor: HairColor.Auburn, facialHair:FacialHair.beardLight(facialHairColor:FacialHairColor.Auburn)),
      eyes:Eyes.squint,
      clothes:Clothes.shirtCrewNeck(ClotheColor.White),
    ),
    Avataaar(
      skin:Skin.light,
      mouth:Mouth.defaultMouth,
      style:Style.circle,
      top:Top.shortHairShortRound(hairColor: HairColor.Black, facialHair:FacialHair.beardMagestic(facialHairColor:FacialHairColor.Black)),
      eyes:Eyes.squint,
      clothes:Clothes.shirtCrewNeck(ClotheColor.White),
    ),
    Avataaar(
      skin:Skin.light,
      mouth:Mouth.twinkle,
      style:Style.circle,
      top:Top.longHairBob(hairColor: HairColor.Brown),
      eyes:Eyes.defaultEyes,
      clothes:Clothes.shirtCrewNeck(ClotheColor.White),
    ),
    Avataaar(
      skin:Skin.pale,
      mouth:Mouth.smile,
      style:Style.circle,
      top:Top.longHairStraight2(hairColor: HairColor.Blonde),
      eyes:Eyes.happy,
      clothes:Clothes.shirtCrewNeck(ClotheColor.White),
    ),
    Avataaar(
      skin:Skin.pale,
      mouth:Mouth.twinkle,
      style:Style.circle,
      top:Top.longHairStraight(hairColor: HairColor.BrownDark, accessoriesType: AccessoriesType.Round),
      eyes:Eyes.squint,
      clothes:Clothes.shirtCrewNeck(ClotheColor.White),
    ),
    Avataaar(
      skin:Skin.pale,
      mouth:Mouth.smile,
      style:Style.circle,
      top:Top.longHairCurly(hairColor: HairColor.Auburn),
      eyes:Eyes.squint,
      clothes:Clothes.shirtCrewNeck(ClotheColor.White),
    ),
    Avataaar(
      skin:Skin.light,
      mouth:Mouth.defaultMouth,
      style:Style.circle,
      top:Top.longHairNotTooLong(hairColor: HairColor.Black),
      eyes:Eyes.squint,
      clothes:Clothes.shirtCrewNeck(ClotheColor.White),
    )
  ];

  Avataaar myAvatar;
  int i=0;

  void _nextAvatar(){
    myAvatar=_avatars[i];
    i++;

  }


  void initState(){
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(seconds:2));

    _topDown = Tween<Offset>(
      begin: Offset(0.0, -1.5),
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

    _controller.forward();
    _nextAvatar();


  }

  Widget _backButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10),
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        color:Colors.grey,
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
      height:MediaQuery.of(context).size.height*.65,
      decoration:BoxDecoration(
          color:Colors.grey[100],
          borderRadius: BorderRadius.vertical(bottom:Radius.circular(15)),
          boxShadow:[BoxShadow(color:Colors.grey, offset:Offset.fromDirection(-5,7), blurRadius:10)]
      ),
      child:Column(
        children: <Widget>[
          _backButton(),
          Container(
            child:Column(
              children: <Widget>[
                Text(
                    'My Profile',
                    style:TextStyle(color:Colors.grey[700], fontWeight:FontWeight.w900, fontSize:24)
                ),
                Container(
                    margin:EdgeInsets.only(bottom:10, top:20),
                    height:100,
                    width:100,
                    child:AvataaarImage(
                      avatar:myAvatar,
                      width:100,
                    )
                ),
                IconButton(
                  icon:Icon(Icons.refresh),
                  iconSize:24,
                  onPressed:(){
                    setState(() {
                      _nextAvatar();
                    });
                  }
                ),
                Text(
                    'Username',
                    style:TextStyle(
                      fontSize:16,
                      fontWeight:FontWeight.bold,
                      color:Colors.lightBlueAccent,
                    )
                ),
              ],
            )
          ),
          Container(
            margin:EdgeInsets.only(top:20),
            child:Column(
              children: <Widget>[
                Text(
                  'Current organization: ',
                  style: TextStyle(color:Colors.grey)
                ),
                RichText(
                  text:TextSpan(
                    style: TextStyle(color:Colors.grey, fontSize:10),
                    children: [
                      TextSpan(
                        text:"Partners In Torah",
                        style:TextStyle(color:Colors.grey, fontSize:18, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:" ("
                      ),
                      TextSpan(
                        text:"change",
                        style:TextStyle(decoration:TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap=(){
                            Navigator.push(context, MaterialPageRoute(builder:(context)=>Search2()));
                          }
                      ),
                      TextSpan(
                          text:")"
                      )
                    ],
                  )
                ),
              ],
            )
          ),
          Container(
            padding:EdgeInsets.fromLTRB(30, 0, 30, 0),
            margin:EdgeInsets.only(top:70),
            child:_maxSlider()
          )
        ],
      )
    );
  }

  Widget _bankInfo(){
    return Padding(
      padding:EdgeInsets.only(bottom:20),
      child:Container(
        margin:EdgeInsets.only(top:30),
        width:MediaQuery.of(context).size.width*.7,
        decoration: BoxDecoration(
            color:Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color:Colors.grey, offset:Offset.fromDirection(.9), blurRadius:10)]
        ),
        child:Column(
          children: <Widget>[
            Container(
              height:20,
              width:MediaQuery.of(context).size.width*.7,
              decoration: BoxDecoration(
                color:Colors.lightBlueAccent.withOpacity(.5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))
              ),
            ),
            Container(
              padding:EdgeInsets.fromLTRB(10, 10, 0, 0),
              alignment:Alignment.centerLeft,
              child:Text(
                'Linked Account',
                style:TextStyle(color:Colors.grey[700], fontSize:16, fontWeight: FontWeight.bold)
              )
            ),
            Container(
              padding:EdgeInsets.fromLTRB(0,0, 10, 10),
              margin:EdgeInsets.only(top:40),
              alignment:Alignment.bottomRight,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.end ,
                children: <Widget>[
                  Text(
                    'Chase Savings (...8859)',
                    style:TextStyle(color:Colors.lightBlueAccent, fontSize:18)
                  ),
                  Text(
                    'Change Account',
                    style:TextStyle(color:Colors.grey, fontSize:12)
                  )
                ],
              )
            )
          ],
        )
      )
    );
  }

  Widget _maxSlider(){
    return Container(
      width:MediaQuery.of(context).size.width*.7,
      child:Column(
        children: <Widget>[
          Slider(
            value: maxChange,
            onChanged:(newMax){
              setState(() {
                maxChange=newMax;
              });
            },
            min:.5,
            max:.99,
            label:"\$${maxChange.toStringAsFixed(2)}",
            divisions:49,
            activeColor: Colors.lightBlueAccent,
            inactiveColor: Colors.grey,
          ),
          Text("Max Change: \$${maxChange.toStringAsFixed(2)}")
        ],
      )

    );
  }

  Widget _randomAvatar(){
    return Container();
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
        child:SingleChildScrollView(
          child:Column(
            children: <Widget>[
              SlideTransition(position:_topDown, child:_accountContainer()),
              SlideTransition(position:_bottomUp, child:_bankInfo()),
            ],
          )
        )
      ),
      extendBody: true,
    );
  }
}
import 'package:change_charity_components/change_charity_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../splash.dart';

class WelcomePage extends StatefulWidget{
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin{
  Animation<Offset> _imageAnim;
  Animation<Offset> _buttonAnim;
  AnimationController _fadeAnimContr;
  AnimationController _imagesAnimContr;
  Animation<Color> _loadingCon;

  bool loading = false;

  void initState() {
    super.initState();

    _fadeAnimContr = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _imagesAnimContr = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    _loadingCon = _fadeAnimContr.drive(
        ColorTween(begin: Colors.lightBlue[200], end: Colors.lightBlue[600]));

    _imageAnim = Tween<Offset>(
      begin:Offset(1.5, 0.0),
      end:Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _imagesAnimContr,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    _buttonAnim = Tween<Offset>(
      begin:Offset(0.0, 1.0),
      end:Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _imagesAnimContr,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    Future<void>.delayed(Duration(milliseconds: 200),(){
      _fadeAnimContr.forward();
    });

    Future<void>.delayed(Duration(milliseconds: 800),(){
      _imagesAnimContr.forward();
    });
  }

  Widget _mainContent(String text, String image) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.04),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              color: Colors.white,
            ),
          ),
        ),
        Spacer(
          flex: 5,
        ),
        Container(
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.06),
          child: Image.asset(image),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromRGBO(0, 174, 229, 1),
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Material(
      color: Color.fromRGBO(0, 174, 229, 1),
      child: Container(
        margin: EdgeInsets.only(top: 80),
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            FadeTransition(
              opacity: _fadeAnimContr,
              child: Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.white
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: SlideTransition(
                  position: _imageAnim,
                  child: Swiper(
                    itemBuilder: (BuildContext context,int index){
                      switch(index){
                        case 0:
                          return _mainContent("Spend \$4.76 on your espresso, and we round up your purchase to \$5.00. The extra \$0.24 goes to your charity of choice.", "images/clip-online-shopping.png");
                          break;
                        case 1:
                          return _mainContent("All your sensitive data is secure and encrypted, with state of the art security.","images/clip-internet-security.png");
                          break;
                        case 2:
                          return _mainContent("All donations are fully tax-deductible. Simply sign up, link your bank, and we'll handle the rest.","images/clip-waiting.png");
                          break;
                        default:
                          return _mainContent("none", "images/clip-online-shopping.png");
                      }
                    },
                    itemCount: 3,
                    pagination: SwiperPagination(
                      builder: new DotSwiperPaginationBuilder(
                          color: Colors.white, activeColor: Color(0xff38547C)),
                    ),
                    scale: 0.6,
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _buttonAnim,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: ChangeSubmitRow(
                  buttonColors: [Colors.blue[900], Colors.blue[900]],
                  loading: loading,
                  onClick: _next,
                  animation: _loadingCon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//  [Colors.blue[900], Colors.blue[900]]
  @override
  void dispose() {
    _fadeAnimContr.dispose();
    _imagesAnimContr.dispose();
    super.dispose();
  }

  void _next () async {
    _imagesAnimContr.animateBack(0, duration: Duration(milliseconds: 800));
    await _fadeAnimContr.animateBack(0, duration: Duration(milliseconds: 800));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("newUser", false);
    Future<void>.delayed(Duration(milliseconds: 100), (){
      Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => Splash()));
    });
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/login.dart';
import 'Pages/homePage.dart';
import 'package:flutter/services.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double _width = 120;
  double _height = 130;
  bool _initScreen;

  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
    _getRoute();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey[50],
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Material(
      color: Colors.grey[50],
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(vertical: _height, horizontal: _width),
        child: Image.asset(
            "images/logo-circle.png",
        ),
        duration: Duration(milliseconds: 1500),
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  void _getRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    _initScreen = token != null ? true : false;


    Future<void>.delayed(Duration(milliseconds: 600), () {
      setState(() {
        _width = 260;
      });
      Future<void>.delayed(Duration(milliseconds: 650), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => _initScreen ? HomePage() : Login()));
      });
    });
  }

//  responsible for checking dynamic link. Sets the shared prefs "selOrg" to the id of the chosen org, which is later consumed
//  by the homepage.
  void initDynamicLinks() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    int selOrg;
    if (deepLink != null) {
      print("first");
      selOrg = int.parse(deepLink.queryParameters["org"]);
      _saveSelectedOrg(selOrg);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          if (deepLink != null) {
            print("second");
            selOrg = int.parse(deepLink.queryParameters["org"]);
            _saveSelectedOrg(selOrg);
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );

  }
  void _saveSelectedOrg(int org) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setInt('selOrg', org);
  }
}

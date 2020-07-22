import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/login.dart';
import 'Pages/homePage.dart';
import 'Pages/emailAuth.dart';
import 'Pages/linkBank.dart';
import 'package:flutter/services.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double _width = 120;
  double _height = 130;
  String _initScreen;
  String _linkBank;
  var email;

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

   _pushRoute() {
     switch(_initScreen){

      case "homepage":{
        return HomePage();
      }
      break;

      case "authpage":{
        return EmailAuth(email, "signup");
      }
      break;

     case "login":{
        return Login();
      }
      break;

      case "forgotpage":{
        return EmailAuth(email, "forgotpass");
      }

      case "linkbank":{
        return LinkBank(_linkBank);
      }
    }
  }

  void _getRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var auth = true;
    email = prefs.getString("signUpEmail");
    _linkBank = prefs.getString("linkBank");
    //if token=null, login
    //if token!=null and email!=null, email logic
    //homepage

    if(email == null) {
      email = prefs.getString("forgotPassEmail");
      auth = false;
    }
    if(token == null){
      _initScreen="login";
    }else if(token!=null &&email!=null){
      if (auth) {
        _initScreen = "authpage";
      } else {
        _initScreen = "forgotpage";
      }
    } else if (token!=null &&_linkBank!=null){
      _initScreen="linkbank";
    } else {
      _initScreen="homepage";
    }

    Future<void>.delayed(Duration(milliseconds: 600), () {
      setState(() {
        _width = 260;
      });
      Future<void>.delayed(Duration(milliseconds: 600), () {
          Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => _pushRoute()));
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

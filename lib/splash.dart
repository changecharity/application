import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/login.dart';
import 'Pages/homePage.dart';

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
    _getRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[50],
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(vertical: _height, horizontal: _width),
        child: Image.asset(
            "images/logo-circle.png",
        ),
        duration: Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  void _getRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    _initScreen = token != null ? true : false;


    Future<void>.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _width = 400;
        _height = 400;
      });
      Future<void>.delayed(Duration(milliseconds: 600), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => _initScreen ? HomePage() : Login()));
      });
    });

  }
}

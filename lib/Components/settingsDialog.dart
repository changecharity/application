import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'securityFaq.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aboutDialog.dart';

import '../Pages/login.dart';

class SettingsDialog extends StatefulWidget {
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<Offset> _paintAnm;
  Animation<Offset> _cardsAnm;

  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(seconds:  1));
    _paintAnm = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.fastLinearToSlowEaseIn
    )
    );

    _cardsAnm = Tween<Offset>(
      begin: Offset(2.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.fastLinearToSlowEaseIn
    )
    );

    Future<void>.delayed(Duration(milliseconds: 500), () {
      controller.forward();
    });
  }

  Widget _FAQ() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
      leading: Icon(Icons.help_outline),
      title: Text('FAQ'),
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return SecurityFAQ();
            },
            fullscreenDialog: true
        ));
      },
    );
  }

  Widget _contactUs() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
      leading: Icon(Icons.people),
      title: Text('Contact Us'),
      subtitle: Text('Questions? Feedback? Need Help?'),
      onTap: (){
        launch('mailto:support@changecharity.io?subject=AppSupport');
      },
    );
  }

  Widget _appInfo() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
      leading: Icon(Icons.info_outline),
      title: Text('App Info'),
      onTap: (){
        showDialog(context: context,
            builder: (context) =>
                AboutChange(),
            barrierDismissible: true);
      },
    );
  }

  Widget _logOutText() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 40,
      width: 50,
      child: MaterialButton(
        child: Text(
          "Log Out",
          style: TextStyle(
            color: Colors.redAccent,
          ),
        ),
        onPressed: _logout,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey[50] : Colors.grey[850],
      appBar: AppBar(
        backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey[50] : Colors.grey[850],
        elevation: 0,
        centerTitle: true,
        title: Text("Settings"),
        iconTheme: IconThemeData(
          color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white,
        ),
      ),
      body: SafeArea(
        child: SlideTransition(
          position: _paintAnm,
          child: SlideTransition(
            position: _cardsAnm,
            child: ListView(
              children: [
                _FAQ(),
                _contactUs(),
                _appInfo(),
                _logOutText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', null);
    Navigator.pushAndRemoveUntil(
        context, PageRouteBuilder(pageBuilder: (_, __, ___) => Login()), (
        route) => false);
  }
}
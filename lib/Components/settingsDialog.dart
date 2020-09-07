import 'package:change/Components/routes.dart';
import 'package:change/Models/userProfileModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'aboutDialog.dart';
import 'securityFaq.dart';

class SettingsDialog extends StatefulWidget {
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> _paintAnm;
  Animation<Offset> _cardsAnm;

  TextStyle errorStyle = TextStyle(color: Colors.redAccent);
  TextStyle captionStyle;

  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _paintAnm = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: controller, curve: Curves.fastLinearToSlowEaseIn));

    _cardsAnm = Tween<Offset>(
      begin: Offset(2.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: controller, curve: Curves.fastLinearToSlowEaseIn));

    Future<void>.delayed(Duration(milliseconds: 500), () {
      controller.forward();
    });
  }

  Widget _FAQ() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
      leading: Icon(Icons.help_outline_rounded),
      title: Text('FAQ'),
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute<Null>(
            builder: (BuildContext context) => SecurityFAQ(),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }

  Widget _contactUs() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
      leading: Icon(Icons.people_outline_rounded),
      title: Text(
        'Contact Us',
      ),
      subtitle: Text(
        'Questions? Feedback? Need Help?',
        style: captionStyle,
      ),
      onTap: () {
        launch('mailto:support@changecharity.io?subject=AppSupport');
      },
    );
  }

  Widget _appInfo() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
      leading: Icon(Icons.info_outline_rounded),
      title: Text('App Info'),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AboutChange(),
          barrierDismissible: true,
        );
      },
    );
  }

  Widget _pauseTrans() {
    return Consumer<UserProfileModel>(
      builder: (context, prof, widget) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
          leading: Icon(prof.getUserRoundUpStatus
              ? Icons.pause_circle_outline_rounded
              : Icons.play_circle_outline_rounded),
          title: Text('Pause Round-Ups'),
          subtitle: Text(
            '${prof.getUserRoundUpStatus ? "Running" : "Paused"}',
            style: prof.getUserRoundUpStatus ? captionStyle : errorStyle,
          ),
          onTap: () =>
              Routes(context: context).setRUStatus(!prof.getUserRoundUpStatus),
        );
      },
    );
  }

  Widget _logOutText() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 60,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Text(
            "Log Out",
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
          onPressed: Routes(context: context).logOut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    captionStyle = TextStyle(
      color: MediaQuery.of(context).platformBrightness == Brightness.light
          ? Colors.grey[700]
          : Colors.grey[400],
    );
    return Scaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.grey[50]
              : Colors.grey[850],
      appBar: AppBar(
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.grey[50]
                : Colors.grey[850],
        elevation: 0,
        centerTitle: true,
        title: Text("Settings"),
        iconTheme: IconThemeData(
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.black
              : Colors.white,
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
                _pauseTrans(),
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
}

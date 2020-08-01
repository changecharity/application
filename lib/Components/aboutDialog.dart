import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutChange extends StatefulWidget {
  @override
  _AboutChangeState createState() => _AboutChangeState();
}

class _AboutChangeState extends State<AboutChange> {
  String version = '';

  @override
  void initState() {
    super.initState();
    _getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return AboutDialog(
      applicationName: 'Change Charity',
      applicationVersion: version,
      applicationLegalese: "© 2020 Change Charity, LLC",
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(25,20,20,0),
          child: Text(
            'Change Charity was created with one goal in mind. To help out non-profits. We have been working tirelessly towards this goal, and really believe this is an incredible step in the right direction. We appreciate all feedback and any ideas of how we can improve our product. ',
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  void _getInfo() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }
}
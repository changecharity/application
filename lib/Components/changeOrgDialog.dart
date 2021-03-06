import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/userOrgModel.dart';

class ChangeOrgDialog extends StatefulWidget {
  @override
  _ChangeOrgDialogState createState() => _ChangeOrgDialogState();

  final int id;

  ChangeOrgDialog(this.id);
}

class _ChangeOrgDialogState extends State<ChangeOrgDialog>
    with TickerProviderStateMixin {
  var token;
  var name = "";
  var logo = "https://wallpaperplay.com/walls/full/b/d/1/58065.jpg";
  var description = "";
  GlobalConfiguration cfg = new GlobalConfiguration();

  void initState() {
    super.initState();
    _getOrgInfo();
  }

  Widget _selectText() {
    return Text(
      'Select Organization?',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _orgInfo() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[_orgLogo(), _orgName(), _orgDescription()],
    ));
  }

  Widget _orgLogo() {
    return Container(
        margin: EdgeInsets.only(top: 15),
        child: logo != null ||
                logo != "" ||
                logo != "https://wallpaperplay.com/walls/full/b/d/1/58065.jpg"
            ? Container(
                height: 100,
                width: 100,
                child: ClipOval(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: "$logo",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search),
                      iconSize: 45,
                    ),
                  ),
                ))
            : Icon(Icons.business, size: 100));
  }

  Widget _orgName() {
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Text('$name',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 174, 229, 1),
                fontSize: 24)));
  }

  Widget _orgDescription() {
    return description != ""
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * .2),
              child: SingleChildScrollView(
                child: Text(
                  '$description',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                    wordSpacing: 2,
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _selectOrgButtons() {
    return Container(
        margin: EdgeInsets.only(top: 15),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_optionButton("No"), _optionButton("Yes")]));
  }

  Widget _optionButton(String option) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          if (option == "No") {
            Navigator.of(context).pop();
          } else if (option == "Yes") {
            _setOrg();
          }
        },
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(60))),
        child: Ink(
          width: 90,
          height: 40,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue[400], Colors.lightBlue[300]],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Center(
              child: Text(option,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Dialog(
            elevation: 15,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _selectText(),
                    _orgInfo(),
                    _selectOrgButtons()
                  ],
                ))));
  }

  void _getOrgInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var content = '{"user_token":"$token", "org":${widget.id}}';
    var response = await http.post("${cfg.getString("host")}/users/getorginfo",
        body: content);
    print(response.body);
    setState(() {
      logo = jsonDecode(response.body)["logo"];
      name = jsonDecode(response.body)["name"];
      var descDecoded = jsonDecode(response.body)["description"];
      descDecoded == null || descDecoded == ""
          ? description = ""
          : description = descDecoded;
    });
  }

  //set the org and notify provider of the new org to show in profile
  void _setOrg() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var content = '{"user_token":"$token", "org":${widget.id}}';
    var response =
        await http.post("${cfg.getString("host")}/users/setorg", body: content);
    print(response.body);
    context.read<UserOrgModel>().notify(name, logo);
    var count = 0;
    Navigator.popUntil(context, (route) => count++ == 2);
  }
}

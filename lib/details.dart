import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class DetailScreen extends StatelessWidget {
  final tag;
  final url;
  final description;
  final context;
  DetailScreen(this.tag, this.url, this.description, this.context);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              Hero(
                tag: tag,
                child: Center(
                  child: GestureDetector(
                    onVerticalDragDown:(d){
                      Navigator.pop(context);
                    },
                    child: Card(
                      margin: EdgeInsets.only(top: 10),
                      borderOnForeground: true,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        child: Container(
                          width: MediaQuery.of(context).size.width/1.2,
                          height: MediaQuery.of(context).size.height/3,
                          child: Image.network(url, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Text(
                  '$description',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 27,
                    letterSpacing: 1,
                  ),
                ),
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                elevation: 8,
                child: Text(
                  'Select',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                color: Colors.purple[300],
                onPressed: (){
                  print(tag);
                  _selectOrg();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _selectOrg() async {
    var content ='{"Id":$tag, "Email":"cool"}';
    var response = await http.post(_address(), body: content);
//    var responseDecode = json.decode(response.body);
    print(response.body);
    if (response.body == "dope") {
      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
    }
  }

  String _address() {
    if (Platform.isAndroid)
      return 'http://10.0.2.2:8080/api/selectedorg';
    else
      return 'http://localhost:8080/api/selectedorg';
  }
}

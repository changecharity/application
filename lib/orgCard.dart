
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'details.dart';
import'./organization.dart';

class OrgCard extends StatelessWidget {
//  this is how you pass in information to different classes
  final backgrndcolor;
  final name;
  OrgCard(this.backgrndcolor, this.name);

  @override
  Widget build(BuildContext context) {
    return _organizationCard();
  }
//  keep the widgets inside the class

  Widget _organizationCard() {
    return Container(
        padding:EdgeInsets.only(bottom:15),
        child:Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: backgrndcolor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400],
                  offset: Offset(7.0, 7.0),
                  blurRadius: 5.0,
                )
              ],
            ),
            width: 140,
            margin: EdgeInsets.only(left: 0, right: 15),
            child: _orgName()
        ),
    );
  }

  Widget _orgName(){
    return Align(
        alignment: Alignment.bottomCenter,
//          the issue was the transparent overlay container doesnt automatically have rounded
//          corners even if the parent does. You did the right thing with adding a border, but
//          it was a tiny bit too small so it didnt look fluid
        child: Container(
          width: 140,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
            ),
            color: Colors.grey[100].withOpacity(0.2),
          ),
          child:Text(
//            this reflects the name of the org
            '$name',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          ),
      ),
    );
  }
}




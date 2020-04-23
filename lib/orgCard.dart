
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'details.dart';
import'./organization.dart';

class OrgCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _organizationCard();
  }
}




Widget _organizationCard() {
  return Container(
    padding:EdgeInsets.only(bottom:15),
    child:Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
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
    )
    //height: 130,

  );
}

Widget _orgName(){
  return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        //height:30,
        width: 140,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5)),
          color: Color.fromRGBO(255, 255, 255, 0.60),
        ),

        child:Text('org name',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
      )
  );
}
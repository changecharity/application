import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'details.dart';
import './organization.dart';

class OrgCard extends StatelessWidget {
//  this is how you pass in information to different classes
  final imageString;
  final name;

  OrgCard(this.imageString, this.name);

  @override
  Widget build(BuildContext context) {
    return _organizationCard();
  }

//  keep the widgets inside the class

  Widget _organizationCard() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      padding: EdgeInsets.only(bottom: 15),
      child: Container(
          width: 180,
          height: 130,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(imageString),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[350],
                offset: Offset(1.0, 1.0),
                blurRadius: 10.0,
              )
            ],
          ),
          child: _orgName()),
    );
  }

  Widget _orgName() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 180,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          color: Colors.white.withOpacity(.7),
        ),
        child: Text(
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

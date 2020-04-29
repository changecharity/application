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
    return _organizationCard(context);
  }

//  keep the widgets inside the class

  Widget _organizationCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      padding: EdgeInsets.only(bottom: 15),
      width: MediaQuery
          .of(context)
          .size
          .width * .42,
      //height: MediaQuery.of(context).size.height*1,
      child: Card(
        elevation: 5,
        color: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageString),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _orgName(context),
            ],
          ),
        ),

      ),
    );
  }

  Widget _orgName(BuildContext context) {
    return
      Container(
        width: MediaQuery
            .of(context)
            .size
            .width * .42,
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
    );
  }
}

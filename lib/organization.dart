import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'details.dart';

import './orgCard.dart';

class Organization extends StatefulWidget {
  @override
  _OrganizationState createState() => _OrganizationState();
}

class _OrganizationState extends State<Organization> {

  Widget _organizationCard() {
    return Container(
        height: MediaQuery
            .of(context)
            .size
            .height * .82,
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        child: _orgName());
  }

  Widget _orgName() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            /*borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5)),*/
            color: Color.fromRGBO(255, 255, 255, 0.60),
          ),
          child: Align(
              alignment: Alignment.center,
              child: Text('Org name',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(5.0, 5.0),
                        blurRadius: 8.0,
                        color: Colors.grey,
                      ),
                    ],
                  ))),
        ));
     }
  Widget _arrowIcon(){
    return Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          color:Colors.blue,
          iconSize: 40,
          onPressed:(){
            Navigator.pop(context);
          }


        )
    );
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: SafeArea(
              child: Column(
                  children: <Widget>[
                    Container(
                      height:MediaQuery.of(context).size.height * .11,
                      color: Colors.grey,
                      padding:EdgeInsets.only(left:10, top:20),
                      child: _arrowIcon()
                    ),

                    Hero(
                      tag: 'org',
                      child: _organizationCard(),

                    ),
                  ])));
    }
  }



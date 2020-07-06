import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import '../SearchPage/details.dart';
import 'organization.dart';

class OrgCard extends StatelessWidget {
//  this is how you pass in information to different classes
  final image;
  final name;
  final tag;

  OrgCard(this.image, this.name, this.tag);

  @override
  Widget build(BuildContext context) {
    return _organizationCard(context);
  }

  Widget _organizationCard(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * .3,
        //margin:EdgeInsets.only(top:40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height:MediaQuery.of(context).size.width * .3,
              child:Hero(
                tag: tag,
                child: Card(
                  elevation: 5,
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ),
            ),
          ),
          _orgName(context),
        ],
      ),
    );
  }
  Widget _orgName(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .25,
      margin:EdgeInsets.only(left:5, top: 3),
      child: Text(
//            this reflects the name of the org
        '$name',
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Organization extends StatefulWidget {
  final color;
  final name;
  final tag;
  Organization(this.color, this.name, this.tag);
  @override
  _OrganizationState createState() => _OrganizationState();
}

class _OrganizationState extends State<Organization> {
  Widget _organizationCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery
          .of(context)
          .size
          .height * .3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
        color: widget.color,
      ),
      child: _backIcon(),
    );
  }

  Widget _backIcon() {
    return Icon(
      Icons.arrow_back,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Hero(
          tag: widget.tag,
          child: Column(
            children: <Widget>[
              _organizationCard(),
            ],
          ),
        ),
      ),
    );
  }
}



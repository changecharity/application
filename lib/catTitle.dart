import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CatTitle extends StatelessWidget{

  final catTitle;
  CatTitle(this.catTitle);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _categoryTitle();
  }

  Widget _categoryTitle() {

    return Container(
        padding: EdgeInsets.only(top:5, bottom:5, left:10, right:10),
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[300],
        ),
        child: Text(catTitle));
  }
}
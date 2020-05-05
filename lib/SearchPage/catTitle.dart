import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CatTitle extends StatelessWidget {
  final catTitle;

  CatTitle(this.catTitle);

  @override
  Widget build(BuildContext context) {
    return _categoryTitle();
  }

  Widget _categoryTitle() {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Container(
        padding: EdgeInsets.only(top: 3, bottom: 3, left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[300].withOpacity(0.7),
        ),
        child: Text(catTitle, style: TextStyle(fontSize:12)),
      ),
    );
  }
}

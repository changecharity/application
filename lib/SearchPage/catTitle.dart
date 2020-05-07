import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CatTitle extends StatelessWidget {
  final catTitle;

  CatTitle(this.catTitle);

  @override
  Widget build(BuildContext context) {
    return _categoryTitle(context);
  }

  Widget _categoryTitle(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Container(
        margin:EdgeInsets.only(left:MediaQuery.of(context).size.width*.05),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[300].withOpacity(0.7),
        ),
        child: Text(
          catTitle,
          style: TextStyle(
            fontWeight:FontWeight.bold,
            fontSize:14,
            color:Colors.grey,
          )
        ),
      ),
    );
  }
}

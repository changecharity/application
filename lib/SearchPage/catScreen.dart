import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'searchedOrganizations.dart';

class CategoryScreen extends StatelessWidget{
  final namesList;
  final imageList;
  final sloganList;

  CategoryScreen(this.namesList, this.imageList, this.sloganList);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body:SafeArea(
            child:Container(
                height:MediaQuery.of(context).size.height,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    _backButton(context),
                    Expanded(
                        child:SearchedOrganizations(namesList, imageList, sloganList)
                    )
                  ],
                )
            )
        )
    );
  }

  Widget _backButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10),
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        color:Colors.grey,
        iconSize: 30,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

}
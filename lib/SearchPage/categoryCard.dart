import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CategoryCard extends StatelessWidget{

  final name;

  CategoryCard(this.name);

  Widget _categoryCard(){
    return Container(
      decoration: BoxDecoration(
        color:Colors.grey[300],
        borderRadius: BorderRadius.circular(100),
        boxShadow: [BoxShadow(color:Colors.grey, offset:Offset(5.0, 5.0), blurRadius: 10)]
      ),
        child:Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.business,
                size:30,
                color:Colors.grey
              ),
              Text('$name', style:TextStyle(fontFamily:'Montserrat', color:Color.fromRGBO(0, 174, 229, 1), fontWeight: FontWeight.bold, fontSize:10))
            ],
          )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _categoryCard();
  }


}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final imageString;
  final name;
  final slogan;

  SearchCard(this.imageString, this.name, this.slogan);

  @override
  Widget build(BuildContext context) {
    return _searchCard(context);
  }

  Widget _searchCard(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20, left: 20),
          height: MediaQuery.of(context).size.height * .1,
          width: MediaQuery.of(context).size.width * .25,
          decoration: BoxDecoration(
            color: Colors.grey,
            image: DecorationImage(
              image: NetworkImage(imageString),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, left: 10),
          height: MediaQuery.of(context).size.height * .1,
          width: MediaQuery.of(context).size.width * .60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$name'.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('$slogan',
                  style: TextStyle(
                      color: Colors.grey[700], fontStyle: FontStyle.italic)),
              Row(
                children: <Widget>[
                  Text('Category Name',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.monetization_on,
                      color: Colors.grey[500],
                      size: 14.0,
                    ),
                  ),
                  Text('50k donors',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12))
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

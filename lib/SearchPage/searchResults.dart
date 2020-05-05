import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'orgCard.dart';

class SearchResults extends StatelessWidget {
  Widget _searchOptions() {
    return Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[_resultCard(context), _resultCard(context)],
              );
            }));
  }

  Widget _resultCard(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 15),
        child: Container(
          height: 130,
          width: MediaQuery.of(context).size.width * .38,
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage('../images/org'),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400],
                offset: Offset(7.0, 7.0),
                blurRadius: 5.0,
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          //color: Colors.grey,
          margin: EdgeInsets.only(left: 15, bottom: 20, top: 20, right: 0),
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.4,
          child: _searchOptions()),
    );
  }
}

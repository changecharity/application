import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final tag;
  final url;
  final description;
  DetailScreen(this.tag, this.url, this.description);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              Hero(
                tag: tag,
                child: Center(
                  child: GestureDetector(
                    onVerticalDragDown:(d){
                      Navigator.pop(context);
                    },
                    child: Card(
                      margin: EdgeInsets.only(top: 10),
                      borderOnForeground: true,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        child: Container(
                          width: MediaQuery.of(context).size.width/1.2,
                          height: MediaQuery.of(context).size.height/3,
                          child: Image.network(url, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Text(
                  '$description',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 27,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

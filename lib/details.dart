import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final tag;
  final imageString;
  final description;
  final slogan;
  final context;

  DetailScreen(this.tag, this.imageString,  this.description,this.slogan, this.context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Hero(
                tag: tag,
                child: Center(
                  child: GestureDetector(
                    onVerticalDragDown: (d) {
                      Navigator.pop(context);
                    },
                    child: Card(
                        margin: EdgeInsets.only(top: 20),
                        borderOnForeground: true,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: NetworkImage(imageString),
                              fit: BoxFit.cover,
                            )),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.1,
                                height: MediaQuery.of(context).size.height / 3,
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                child: Text(
                  '$description',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 27,
                    letterSpacing: 1,
                  ),
                ),
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                elevation: 8,
                child: Text(
                  'Select',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                color: Colors.lightBlueAccent,
                onPressed: () {
                  print(tag);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

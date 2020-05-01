import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '././Services/calls_and_messages_service.dart';
import "././Services/service_locator.dart";

class DetailScreen extends StatelessWidget {
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  final number = '4242280919';
  final emailAddress = 'batyashaps1@gmail.com';

  final tag;
  final imageString;
  final description;
  final slogan;
  final context;

  DetailScreen(
      this.tag, this.imageString, this.description, this.slogan, this.context);

  @override
  Widget build(BuildContext context) {
    return _detailsPage();
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Hero(
          tag: tag,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, size: 24, color: Colors.black),
          ),
        ),
        Icon(Icons.search, size: 24, color: Colors.black),
      ],
    );
  }

  Widget _logoAndName(BuildContext context) {
    return Container(
        //color: Colors.blue[200],
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.width * .3,
            width: MediaQuery.of(context).size.width * .3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey,
                image: DecorationImage(
                  image: NetworkImage(imageString),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
              height: MediaQuery.of(context).size.width * .3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    '$description',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    child: Text(
                      '"$slogan"',
                      style: TextStyle(
                          color: Colors.black, fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: _callIcon(),
                          onPressed: () {
                            _service.call(number);
                          }),
                      IconButton(
                          icon: _textIcon(),
                          onPressed: () {
                            _service.sendSms(number);
                          }),
                      IconButton(
                          icon: _emailIcon(),
                          onPressed: () {
                            _service.sendEmail(emailAddress);
                          }),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _callIcon() {
    return Icon(
      Icons.call,
      size: 20,
      color: Colors.grey,
    );
  }
  Widget _textIcon() {
    return Icon(
      Icons.sms,
      size: 20,
      color: Colors.grey,
    );
  }
  Widget _emailIcon() {
    return Icon(
      Icons.email,
      size: 20,
      color: Colors.grey,
    );
  }

  Widget _categoryAndDonors() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1.0, color: Colors.grey))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.monetization_on, size: 24, color: Colors.black),
                    Text('50k Donors',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ))
                  ],
                )),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.local_florist, size: 24, color: Colors.black),
                Text('Jewish',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ))
              ],
            )),
          ),
        ],
      ),
      //color: Colors.blue[300],
    );
  }

  Widget _donateButton(context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width * 1,
        child: RaisedButton(
          onPressed: () {},
          color: Colors.blueAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text('Donate',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ));
  }

  Widget _media(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: MediaQuery.of(context).size.width * .4,
          child: Card(
            color: Colors.blue[int.parse('${index + 1}00')],
            margin: EdgeInsets.only(right: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      },
    );
  }

  Widget _about() {
    return Container(
        //color: Colors.blue[600],
        padding: EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'About $description:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
                'The Jewish study network inspires people all across the bay area and is a fun place to visit...etc etc',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ))
          ],
        ));
  }

  Widget _detailsPage() {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: _header(),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.loose,
                child: _logoAndName(context),
              ),
              Flexible(
                flex: 1,
                child: _categoryAndDonors(),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: _donateButton(context),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: _media(context),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _about(),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*Scaffold(
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
    );*/
}

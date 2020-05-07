import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Services/calls_and_messages_service.dart';
import '../Services/service_locator.dart';

class DetailScreen extends StatelessWidget {
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  final number = '4242280919';
  final emailAddress = 'batyashaps1@gmail.com';

  final tag;
  final image;
  final description;
  final slogan;
  final context;

  DetailScreen(this.tag, this.image, this.description, this.slogan,
      this.context);

  Widget _backButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10),
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        iconSize: 30,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _orgLogoHero(){
    return Container(
      width:MediaQuery.of(context).size.width*.5,
      child:AspectRatio(
        aspectRatio: 1/1,
        child:Hero(
          tag: tag,
          child:Card(
            elevation:5,
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
            ),
            child:ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child:Container(
                decoration:BoxDecoration(
                  image: DecorationImage(
                    image:image,
                    fit:BoxFit.cover
                  ),
                )
              )
            )
          )
        )
      )
    );
  }

  Widget _orgName(){
    return Container(
      margin:EdgeInsets.only(top:10),
      //color:Colors.grey,
      child:Text(
        '$description',
        style:TextStyle(
          fontFamily:'Montserrat',
          fontSize:24,
          fontWeight:FontWeight.bold,
          color:Colors.grey[700],

        )
      )
    );
  }

  Widget _donateButton(BuildContext context){
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(0, 174, 229,1),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(color:Colors.grey, offset:Offset(2.5,2.5), blurRadius:5.0)]
        ),
        child: IconButton(
          padding:EdgeInsets.all(18),
          color: Colors.white,
          icon: Icon(Icons.attach_money),
          iconSize:25,
          tooltip: 'Donate',
          onPressed: () {}
        )
      )
    );
  }

  Widget _detailsContainer(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height *.45,
      margin:EdgeInsets.only(top:60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),),
        color: Colors.grey[100],
        boxShadow: [BoxShadow(
          color: Colors.grey[350],
          blurRadius: 10.0,
          offset: Offset.fromDirection(5, 7),
        ),],
      ),
      child: _details()
    );
  }

  _details(){
    return Container(
      padding:EdgeInsets.fromLTRB(20, 30, 20, 30),
      child:Column(
        mainAxisAlignment:MainAxisAlignment.start,
        children: <Widget>[
          Text(
            '"$slogan"',
            overflow:TextOverflow.ellipsis,
            style:TextStyle(
              color:Colors.lightBlueAccent,
              fontSize:20,
              fontWeight:FontWeight.bold,
              fontStyle:FontStyle.italic
            )
          ),
          Container(
            margin:EdgeInsets.only(top:30),
            alignment: Alignment.centerLeft,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'About:',
                      style:TextStyle(
                        fontWeight:FontWeight.bold,
                        color:Colors.grey,
                        fontSize: 20,
                      )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*.22,
                      child: Text(
                          'The Jewish study network inspires people all across the bay area and is a fun place to visit...etc etc'
                      )
                    )
                  ],
                ),
                Container(
                  //padding:EdgeInsets.symmetric(horizontal:10),
                  width:MediaQuery.of(context).size.width*.6,
                  height:MediaQuery.of(context).size.height*.3,
                  child: ListWheelScrollView(
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal:10),
                        child:Container(
                          decoration:BoxDecoration(
                            color:Colors.grey[int.parse('${index+2}00')],
                            borderRadius: BorderRadius.circular(20),
                          )
                        )
                      );
                      }
                    ),
                    itemExtent:130,
                    diameterRatio: 1.5,
                  )
                )
              ],
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        //child:SingleChildScrollView(
           child:Container(
             height:MediaQuery.of(context).size.height,
             child:Column(
               mainAxisAlignment: MainAxisAlignment.end,
               children: <Widget>[
                 _backButton(),
                 _orgLogoHero(),
                 _orgName(),
                 _detailsContainer()
               ],
             )
           )
        //)
      ),
      extendBody: true,
      floatingActionButton:_donateButton(context)
    );
  }


//  Widget _header() {
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      children: <Widget>[
//        IconButton(
//          icon: Icon(Icons.arrow_back, size: 24, color: Colors.black),
//        ),
//      ],
//    );
//  }
//
//  Widget _logoAndName(BuildContext context) {
//    return Container(
//      margin: EdgeInsets.only(bottom: MediaQuery
//          .of(context)
//          .size
//          .height * 0.05),
//      //color: Colors.blue[200],
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          Flexible(
//            flex: 1,
//            child: Hero(
//              tag: tag,
//              child: SizedBox(
//                height: MediaQuery
//                    .of(context)
//                    .size
//                    .width * .3,
//                width: MediaQuery
//                    .of(context)
//                    .size
//                    .width * .3,
//                child: Container(
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(15),
//                    color: Colors.grey,
//                    image: DecorationImage(
//                      image: image,
//                      fit: BoxFit.cover,
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          ),
//          Flexible(
//            flex: 2,
//            child: Align(
//              alignment: Alignment.centerLeft,
//              child: Container(
//                padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
//                height: MediaQuery
//                    .of(context)
//                    .size
//                    .width * .3,
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    Text(
//                      '$description',
//                      style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 20,
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                    Container(
//                      child: Text(
//                        '"$slogan"',
//                        style: TextStyle(
//                            color: Colors.black, fontStyle: FontStyle.italic),
//                      ),
//                    ),
////                    Container(
////                        child: Row(
////                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
////                          children: <Widget>[
////                            IconButton(
////                                icon: _callIcon(),
////                                onPressed: () {
////                                  _service.call(number);
////                                }),
////                            IconButton(
////                                icon: _textIcon(),
////                                onPressed: () {
////                                  _service.sendSms(number);
////                                }),
////                            IconButton(
////                                icon: _emailIcon(),
////                                onPressed: () {
////                                  _service.sendEmail(emailAddress);
////                                }
////                            ),
////                          ],
////                        )),
//                  ],
//                ),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  Widget _callIcon() {
//    return Icon(
//      Icons.call,
//      size: 20,
//      color: Colors.grey,
//    );
//  }
//
//  Widget _textIcon() {
//    return Icon(
//      Icons.sms,
//      size: 20,
//      color: Colors.grey,
//    );
//  }
//
//  Widget _emailIcon() {
//    return Icon(
//      Icons.email,
//      size: 20,
//      color: Colors.grey,
//    );
//  }
//
//  Widget _categoryAndDonors() {
//    return Container(
//      child: Row(
//        children: <Widget>[
//          Flexible(
//            fit: FlexFit.tight,
//            flex: 1,
//            child: Container(
//              decoration: BoxDecoration(
//                border: Border(
//                  right: BorderSide(width: 1.0, color: Colors.grey),
//                ),
//              ),
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  Icon(Icons.monetization_on, size: 24, color: Colors.grey),
//                  Text('50k Donors',
//                    style: TextStyle(
//                      color: Colors.black,
//                      fontSize: 12,
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//          Flexible(
//            flex: 1,
//            fit: FlexFit.tight,
//            child: Container(
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    Icon(Icons.local_florist, size: 24, color: Colors.grey),
//                    Text('Jewish',
//                      style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 12,
//                      ),
//                    ),
//                  ],
//                )),
//          ),
//        ],
//      ),
//      //color: Colors.blue[300],
//    );
//  }
//
//  Widget _donateButton(context) {
//    return Container(
//      padding: EdgeInsets.symmetric(vertical: 20),
//      width: MediaQuery
//          .of(context)
//          .size
//          .width * 1,
//      child: RaisedButton(
//        onPressed: () {},
//        color: Colors.blueAccent,
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//        child: Text(
//          'Donate',
//          style: TextStyle(
//            fontSize: 16,
//            fontWeight: FontWeight.bold,
//            color: Colors.white,
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget _media(BuildContext context) {
//    return ListView.builder(
//      scrollDirection: Axis.horizontal,
//      itemCount: 5,
//      itemBuilder: (BuildContext context, int index) {
//        return Container(
//          width: MediaQuery
//              .of(context)
//              .size
//              .width * .4,
//          child: Card(
//            color: Colors.blue[int.parse('${index + 1}00')],
//            margin: EdgeInsets.only(right: 20),
//            shape:
//            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//          ),
//        );
//      },
//    );
//  }
//
//  Widget _about() {
//    return Container(
//      //color: Colors.blue[600],
//      padding: EdgeInsets.only(top: 40),
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Text(
//                'About $description:',
//                style: TextStyle(
//                  fontSize: 16,
//                  color: Colors.black,
//                  fontWeight: FontWeight.bold,
//                ),
//              ),
//            ],
//          ),
//          Text(
//            'The Jewish study network inspires people all across the bay area and is a fun place to visit...etc etc',
//            style: TextStyle(
//              fontSize: 14,
//              color: Colors.black54,
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  Widget _detailsPage() {
//    return Scaffold(
//      body: SafeArea(
//        child: Container(
//          width: MediaQuery
//              .of(context)
//              .size
//              .width,
//          height: MediaQuery
//              .of(context)
//              .size
//              .height,
//          margin: EdgeInsets.symmetric(horizontal: 20),
//          child: GestureDetector(
//            onVerticalDragDown: (s) {
//              print(s.localPosition.distance);
//              if (s.localPosition.distance < 300) {
//                Navigator.pop(context);
//              }
//            },
//            child: Column(
//              children: <Widget>[
//                Flexible(
//                  flex: 1,
//                  fit: FlexFit.tight,
//                  child: _header(),
//                ),
//                Flexible(
//                  flex: 2,
//                  fit: FlexFit.loose,
//                  child: _logoAndName(context),
//                ),
//                Flexible(
//                  flex: 1,
//                  child: _categoryAndDonors(),
//                ),
////                Flexible(
////                  flex: 3,
////                  fit: FlexFit.tight,
////                  child: _media(context),
////                ),
//                Flexible(
//                  flex: 2,
//                  fit: FlexFit.tight,
//                  child: _about(),
//                ),
//                Flexible(
//                  flex: 1,
//                  fit: FlexFit.loose,
//                  child: _donateButton(context),
//                )
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
  }


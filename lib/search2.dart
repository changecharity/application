import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'details.dart';
import './orgCard.dart';
import './catTitle.dart';
import 'paintings.dart';
import './orgCard.dart';
import './searchCard.dart';
import './searchBar.dart';
import './searchedOrganizations.dart';
import './login.dart';
import 'package:carousel_pro/carousel_pro.dart';

class Search2 extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search2> {
  var _orgNames = [
    "Emek Beracha",
    "Jewish Study Network",
    "Meira Academy",
    "Torah Anytime",
    "Bonei Olam",
    "Olami",
    "Partners in Torah",
    "Zaka"
  ];
  var _orgImages = [
    NetworkImage("https://images.shulcloud.com/1450/logo/1550604879.img"),
    NetworkImage("http://www.jsn.info/uploads/1/9/1/2/19123279/published/1393271267.png?1513880506"),
    NetworkImage("https://www.meiraacademy.org/uploads/1/9/1/2/19123279/download_orig.png"),
    NetworkImage("https://www.torahanytime.com/static/images/logo.png"),
    NetworkImage("https://www.boneiolam.org/images/bonei_olam_logo.jpg"),
    NetworkImage( "http://www.firstnonprofit.org/wp-content/uploads/2019/07/Olami-logo.jpg"),
    NetworkImage("https://www.partnersintorah.org/wp-content/uploads/2017/12/partners-in-torah-white-logomark.png"),
    NetworkImage("https://upload.wikimedia.org/wikipedia/en/a/a4/Zaka01.png"),
  ];

  List<NetworkImage>_orgImagesList(){
    if(_orgImages.length>=12){
      return _orgImages.sublist(0,12);
    }
    return _orgImages;
  }

  var _orgSlogans = [
    "An Orthodox shul for everyone",
    "Raising the level of Jewish Literacy",
    "Empowering young Jewish Women",
    "More than 7,500,000 hours of Torah a year is being learned through TorahAnytime",
    "Creating Families. Building Eternity.",
    "Inspiring Jewish Greatness",
    "Jewish Journeys, custom made...",
    "Being ready for whatever tomorrow brings"
  ];

  var _orgCategories = [
    "Shuls",
    "Yeshivas",
    "Sick",
    "Poor"
  ];

  Widget _searchNavIcon() {
    return Material(
        color: Colors.transparent,
        child: Center(
            child: Ink(
                decoration: ShapeDecoration(
                  color: Colors.grey[300],
                  shape: CircleBorder(),
                ),
                child: IconButton(
                    color: Colors.grey[600],
                    icon: Icon(Icons.search),
                    tooltip: 'My Account',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    }))));
  }

  Widget _accountNavIcon() {
    return Material(
        color: Colors.transparent,
        child: Center(
            child: Ink(
                decoration: ShapeDecoration(
                    color: Colors.grey[300], shape: CircleBorder()),
                child: IconButton(
                    color: Colors.grey[600],
                    icon: Icon(Icons.perm_identity),
                    tooltip: 'My Account',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    }))));
  }

  Widget _imageCarousel() {
    return SizedBox(
      height:MediaQuery.of(context).size.height*.25,
      width:MediaQuery.of(context).size.width*.5,
        child:Carousel(
          autoplay: false,
          images: _orgImagesList(),
          dotSize:4.0,
          showIndicator: true,
          dotSpacing: 10,
          boxFit:BoxFit.cover,
          borderRadius:true,
          radius:Radius.circular(25),
          dotVerticalPadding: 0,
          dotColor:Colors.black54,
          dotBgColor: Colors.transparent,
          dotIncreasedColor:Colors.black87,
          indicatorBgPadding: 10,
        )
    );
  }

  Widget _browseContainer(){
    return Container(
      decoration:BoxDecoration(
        color:Colors.grey[100],
        borderRadius:BorderRadius.only(topLeft:Radius.circular(25), topRight:Radius.circular(25)),
        boxShadow: [BoxShadow(
          color: Colors.grey[350],
          blurRadius: 10.0,
          offset: Offset.fromDirection(5, 7),
        ),],
      ),
      child:_browseList()
    );
  }

  Widget _browseList(){
    return Column(children:[
      Container(
        margin:EdgeInsets.only(top:30, left:MediaQuery.of(context).size.width*.05),
        height:MediaQuery.of(context).size.height*.1,
        child:_categoryListView()
    ),
    ]);
  }

  Widget _categoryListView(){
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _orgCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width:MediaQuery.of(context).size.width*.3,
            margin:EdgeInsets.only(right:MediaQuery.of(context).size.width*.05),
            child:Column(
              children: <Widget>[
                Icon(
                  Icons.favorite,
                  size: 30,
                  color:Colors.grey
                ),
                Text(
                  _orgCategories[index],
                  textAlign: TextAlign.center,
                )
              ],
            )
          );
        }
    );
  }

  Widget _mainBody() {
    return Container(
        //child: _mainBodyContent(),
        child:Column(
          children: <Widget>[
            Container(
                margin:EdgeInsets.only(top: MediaQuery.of(context).size.height * .1),
                child: _imageCarousel()),
            Container(
              margin:EdgeInsets.only(top: MediaQuery.of(context).size.height * .1),
              height: MediaQuery.of(context).size.height*.48,
              child:_browseContainer(),
            ),
          ],
        )
        );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  child: _mainBody(),
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height * .03,
                    left: MediaQuery.of(context).size.width * .05,
                    child: _accountNavIcon()),
                Positioned(
                    top: MediaQuery.of(context).size.height * .03,
                    right: MediaQuery.of(context).size.width * .05,
                    child: _searchNavIcon()),
              ],
            )
        ),
      ),
      extendBody: true,
    );
  }
}

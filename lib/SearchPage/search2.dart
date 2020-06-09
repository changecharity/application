import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'details.dart';
import 'orgCard.dart';
import 'catTitle.dart';
import '../paintings.dart';
import 'orgCard.dart';
import 'searchCard.dart';
import 'searchButton.dart';
import 'searchedOrganizations.dart';
import '../Pages/login.dart';
import 'categoryCard.dart';
import 'catScreen.dart';


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
    NetworkImage("https://upload.wikimedia.org/wikipedia/en/a/a4/Zaka01.png")
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
    "Sick",
    "Poor",
    "Education",
    "Elderly",
    "Children",
    "Schools",
    "Sick",
    "Poor",
    "Elderly"
  ];


  Widget _backButton() {
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


 Widget _featuredList(){
    return Container(
      height:MediaQuery.of(context).size.height*.25,
      margin:EdgeInsets.only(top: MediaQuery.of(context).size.height * .02),
      child: ListView.builder(
        scrollDirection:Axis.horizontal,
        itemCount:_orgNames.length,
        itemBuilder:(BuildContext context, int index){
          return Container(
            margin:EdgeInsets.only(right:30),
            width:MediaQuery.of(context).size.width*.4,
            decoration:BoxDecoration(
              color:Colors.grey[300],
              borderRadius:BorderRadius.only(bottomLeft:Radius.circular(20), topRight:Radius.circular(20))
            ),
            child:Container(
              padding:EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*.05),
              child: GestureDetector(
                onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        '${index}tag',
                        _orgImages[index],
                        _orgNames[index],
                        _orgSlogans[index],
                        context,
                      ),
                    )
                  );
                },
                child:OrgCard(_orgImages[index], _orgNames[index], '${index}tag')
              )
            )
          );
        }
      )
    );
 }

  Widget _categoriesText() {
    return Container (
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width*.05,
        MediaQuery.of(context).size.height*.05,
        0,
        0
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        'Categories',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _browseContainer(){
    return Container(
      alignment: Alignment.bottomCenter,
      margin:EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
      height: MediaQuery.of(context).size.height * .45,
      decoration:BoxDecoration(
        color:Colors.grey[100],
        borderRadius:BorderRadius.only(topLeft:Radius.circular(25), topRight:Radius.circular(25)),
        boxShadow: [BoxShadow(
          color: Colors.grey[350],
          blurRadius: 10.0,
          offset: Offset.fromDirection(5, 7),
        )]
      ),
      child:Container(
        child:GridView.count(
          crossAxisCount: 3,
          padding:EdgeInsets.all(40),
          crossAxisSpacing: 40,
          mainAxisSpacing:40,
          children: List.generate(_orgCategories.length, (index){
              return GestureDetector(
                onTap:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder:(context)=>CategoryScreen(_orgNames, _orgImages, _orgSlogans))
                  );
                },
                child:CategoryCard(_orgCategories[index])
              );
            }
          )
        )
      )
    );
  }


  Widget _mainBody() {
    return Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _backButton(),
            CatTitle('Featured Organizations'),
            _featuredList(),
            _categoriesText(),
            _browseContainer()
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
          child: Stack(
            children: <Widget>[
              Container(
                child: _mainBody(),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * .02,
                right: MediaQuery.of(context).size.width *.04 ,
                child: SearchButton()
              ),
            ],
          )
        ),
      ),
      extendBody: true,
    );
  }
}

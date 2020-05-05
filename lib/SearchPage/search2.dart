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
import '../login.dart';
import 'featuredCarousel.dart';
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


  Widget _arrowNavIcon() {
    return IconButton(
      color: Colors.grey[700],
      iconSize: 24,
      icon: Icon(Icons.arrow_back),
      tooltip: 'My Account',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    );
  }

  Widget _imageCarousel() {
    return Column(
      children: <Widget>[
        Container(
          margin:EdgeInsets.only(bottom:10),
          child:Text(
            'Featured',style:TextStyle(fontSize:16, fontWeight:FontWeight.bold, color:Colors.grey[600]),

          ),
        ),
        SizedBox(
          height:MediaQuery.of(context).size.height*.2,
          width:MediaQuery.of(context).size.width*.9,
          child: Container(
            child:FeaturedCarousel()
          ),
        ),
        Container(
          margin:EdgeInsets.only(top:10),
          child:Text(
            'OrgName',
          ),
        )
      ],
    );
  }
//        child:Stack(
//          children: <Widget>[
//            Carousel(
//              autoplay: false,
//              images: _orgImagesList(),
//              dotSize:4.0,
//              showIndicator: true,
//              dotSpacing: 10,
//              //boxFit:BoxFit.cover,
//              borderRadius:true,
//              radius:Radius.circular(25),
//              dotVerticalPadding: 0,
//              dotColor:Colors.black54,
//              dotBgColor: Colors.transparent,
//              dotIncreasedColor:Colors.black87,
//              indicatorBgPadding: 10,
//            ),
//            Container(
//              height:35,
//              alignment: AlignmentDirectional.center,
//              width:MediaQuery.of(context).size.width*.5,
//              decoration:BoxDecoration(
//                borderRadius:BorderRadius.only(topLeft:Radius.circular(25), topRight:Radius.circular(25), bottomRight: Radius.circular(25)),
//                color:Colors.grey.withOpacity(.5)
//              ),
//              child:Text('Featured', style:TextStyle(fontWeight:FontWeight.bold, fontSize:18, color:Colors.grey[700]))
//            )
//          ],
//        )



  Widget _browseContainer(){
    return Container(
      margin:EdgeInsets.only(top: MediaQuery.of(context).size.height * .04),
      height: MediaQuery.of(context).size.height*.51,
      decoration:BoxDecoration(
        color:Colors.grey[100],
        borderRadius:BorderRadius.only(topLeft:Radius.circular(25), topRight:Radius.circular(25)),
        boxShadow: [BoxShadow(
          color: Colors.grey[350],
          blurRadius: 10.0,
          offset: Offset.fromDirection(5, 7),
        ),
      ]),
      child:Column(
        children: <Widget>[
          _browseCatList(),
          Flexible(
            child:FractionallySizedBox(
              heightFactor:1.0,
              child:Container(
                //color:Colors.grey,
                padding:EdgeInsets.only(left:MediaQuery.of(context).size.width*.05),
                child:_browseOrgList(),
              )
            )
          )
        ]
      )
    );
  }

  Widget _browseCatList(){
    return Column(children:[
      Container(
        margin:EdgeInsets.only(top: 20, left:MediaQuery.of(context).size.width*.05),
        height:MediaQuery.of(context).size.height*.08,
        child:_categoryListView()
    ),
    ]);
  }

  Widget _browseOrgList(){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount:_orgCategories.length,
      itemBuilder: (BuildContext context, int rowIndex){
        return Container(
          height:MediaQuery.of(context).size.height*.25,
          margin: rowIndex==0 ? EdgeInsets.only(top:10) :EdgeInsets.only(top:5),
          child:Column(
            children: <Widget>[
              Flexible(flex:1,child:CatTitle(_orgCategories[rowIndex])),
              Flexible(flex:4,child:ListView.builder(
                scrollDirection:Axis.horizontal,
                itemCount:_orgNames.length,
                itemBuilder:(BuildContext context, int orgIndex){
                  return Container(
                    margin: orgIndex==0 ? EdgeInsets.only(left:0):EdgeInsets.only(left:15),
                    child:GestureDetector(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => DetailScreen('${rowIndex}org$orgIndex', _orgImages[orgIndex], _orgNames[orgIndex], _orgSlogans[orgIndex],context ))
                        );
                      },
                      child:OrgCard(
                        _orgImages[orgIndex],
                        _orgNames[orgIndex],
                        '${rowIndex}org$orgIndex',
                      )
                    )
                  );
                }
              ))
            ],
          )

        );
      }
    );
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
                height:MediaQuery.of(context).size.height*.3,
                margin:EdgeInsets.only(top: MediaQuery.of(context).size.height * .08),
                child: _imageCarousel()
            ),
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
            //height: MediaQuery.of(context).size.height,
            //width: MediaQuery.of(context).size.width,
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  child: _mainBody(),
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height * .02,
                    left: MediaQuery.of(context).size.width *.02 ,
                    child: _arrowNavIcon()
                ),
                Positioned(
                    bottom: MediaQuery.of(context).size.height * .03,
                    right: MediaQuery.of(context).size.width *.03 ,
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

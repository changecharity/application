import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'details.dart';
import './organization.dart';
import './orgCard.dart';
import './catTitle.dart';
import './searchResults.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController;
  var _orgNames = [
    "emek beracha",
    "jsn",
    "meira",
    "torah anytime",
    "bonei olam",
    "olami",
    "partners in torah",
    "zaka"
  ];
  var _orgImages = [
    "https://images.shulcloud.com/1450/logo/1550604879.img",
    "http://www.jsn.info/uploads/1/9/1/2/19123279/published/1393271267.png?1513880506",
    "https://www.meiraacademy.org/uploads/1/9/1/2/19123279/download_orig.png",
    "https://www.torahanytime.com/static/images/logo.png",
    "https://www.boneiolam.org/images/bonei_olam_logo.jpg",
    "http://www.firstnonprofit.org/wp-content/uploads/2019/07/Olami-logo.jpg",
    "https://www.partnersintorah.org/wp-content/uploads/2017/12/partners-in-torah-white-logomark.png",
    "https://upload.wikimedia.org/wikipedia/en/a/a4/Zaka01.png"
  ];
  var _orgCategories = ["Featured", "Recommended", "Jewish Categories"];
  var _isVisible = true;

  void showContainer(){
    setState((){
      _isVisible=!_isVisible;
    });
  }

  Widget _searchBar() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      width: MediaQuery.of(context).size.width / 1.15,
      height: MediaQuery.of(context).size.height / 14,
      child: TextField(
        onTap: showContainer,
        style: TextStyle(
          fontSize: 18,
        ),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: _searchIcon(),
          labelText: 'Search For Organizations',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        //onSubmitted: (s) => _getOrganizations(),
      ),
    );
  }

  Widget _searchIcon() {
    return Icon(
      Icons.search,
      color: Colors.grey[400],
    );
  }

  Widget _submit() {
    return RaisedButton(
      elevation: 10,
      onPressed: () {
//         Navigator.push(
////            context,
////            MaterialPageRoute(builder: (context) => Organization()),
////          );
      },
    );
  }

  Widget _searchedOrganizations() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 40),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        //child: _scrollingList(),
      ),
    );
  }

  Widget _organizationContainer() {
    return Visibility(
        visible: _isVisible,
        replacement: SearchResults(),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.only(left: 10, bottom: 20, top:20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.4,
              child: _organizationList()
              // child: _testList(),
              ),
        ));
  }

/*
Widget _scrollingList() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            borderOnForeground: true,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
        child: GestureDetector(
           onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
               return DetailScreen(_organizations[0][i], _organizations[1][i], _organizations[2][i], context);
             }));},
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              child: Container(
                width: 300,
               child: Hero(
                  tag: '${_organizations[0][i]}',
                  child: Image.network(_organizations[1][i], fit: BoxFit.fill),
               ),
              ),
            ),
/         ),
  );
});
}*/

//  Widget _testList() {
//    return ListWheelScrollView(
//      //children: _slvChildren(),
//      itemExtent: 15,
//      magnification: 1.2,
//      useMagnifier: false,
//    );
//  }

//  List<Widget> _slvChildren() {
//    if (_organizations.length == 0){
//      return List<Widget>.generate(
//        10,
//        (i) => Text('dope'),
//      );
//    }
//    else{
//      return List<Widget>.generate(
//        _organizations.length,
//            (i) => GestureDetector(
//          onTap: () {
//            Navigator.push(context, MaterialPageRoute(builder: (_) {
//              print('dope');
//              return DetailScreen(_organizations[0][i], _organizations[1][i], _organizations[2][i], context);
//            }));
//          },
//          child: Container(
//            margin: EdgeInsets.symmetric(vertical: 10),
//            decoration: BoxDecoration(
//              borderRadius: BorderRadius.all(Radius.circular(15)),
//              color: Colors.green[100*(i+1)],
//            ),
//            width: 230,
//            height: 300,
//            child: Image.network(_organizations[1][i], fit: BoxFit.fill),
//          ),
//        ),
//      );
//    }
//  }
  Widget _organizationList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 3,
        itemBuilder: (BuildContext context, int rowindex) {
          return Container(
            height: MediaQuery.of(context).size.height * .20,
            margin: EdgeInsets.only(top: 60),
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                ListView.builder(
                    scrollDirection: Axis.horizontal,
//         changed this to reflect a length of an array
                    itemCount: _orgNames.length,
                    itemBuilder: (BuildContext context, int orgindex) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                    '${rowindex}org$orgindex',
                                    _orgImages[orgindex],
                                    _orgNames[orgindex],
                                    context)),
                          );
                        },
                        child: Hero(
                            // its important to pass the identical tag to the hero widget so it can animate
                            // the hero widget basically takes its content and expands it into a new page
                            tag: '${rowindex}org$orgindex',
//                  im passing in a color, and the org name
                            child: OrgCard(
                                _orgImages[orgindex], _orgNames[orgindex])),
                      );
                    }),
                Positioned(
                  top: -40,
                  child: CatTitle(_orgCategories[rowindex]),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                _searchBar(),
//                _searchedOrganizations(),
                _organizationContainer(),
                _submit(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

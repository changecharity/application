import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'details.dart';
import './orgCard.dart';
import './catTitle.dart';
import 'paintings.dart';
import './orgCard.dart';

class Search extends StatefulWidget{
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  AnimationController _searchAnController;
  AnimationController _browseAnController;
  Animation<Offset> _searchAn;
  Animation<Offset> _browseAn;
  TextEditingController searchController;
  bool _bodyState = false;
  bool _shouldSwitch = true;
  static var _orgNames = [
    "emek beracha",
    "jsn",
    "meira",
    "torah anytime",
    "bonei olam",
    "olami",
    "partners in torah",
    "zaka"
  ];
  static var _orgImages = [
    "https://images.shulcloud.com/1450/logo/1550604879.img",
    "http://www.jsn.info/uploads/1/9/1/2/19123279/published/1393271267.png?1513880506",
    "https://www.meiraacademy.org/uploads/1/9/1/2/19123279/download_orig.png",
    "https://www.torahanytime.com/static/images/logo.png",
    "https://www.boneiolam.org/images/bonei_olam_logo.jpg",
    "http://www.firstnonprofit.org/wp-content/uploads/2019/07/Olami-logo.jpg",
    "https://www.partnersintorah.org/wp-content/uploads/2017/12/partners-in-torah-white-logomark.png",
    "https://upload.wikimedia.org/wikipedia/en/a/a4/Zaka01.png"
  ];
  //var _searchedImages = _orgImages.contains(_searchedNames);
  //var _searchedNames =_orgNames.contains(searchController.text);
  var _orgCategories = ["Featured", "Recommended", "Jewish Categories"];
  var _isVisible = true;
  void showContainer(){
    setState((){
      _isVisible=!_isVisible;
    });
  }

  void initState() {
    super.initState();
    _searchAnController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _browseAnController = AnimationController(vsync: this, duration: Duration(milliseconds: 900));

    _searchAn = Tween<Offset>(
      begin: Offset(0.0, 1.5),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _searchAnController,
      curve: Curves.easeInOutCubic,
    ));

    _browseAn = Tween<Offset>(
      begin: Offset(1.5, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _browseAnController,
      curve: Curves.easeInOutCubic,
    ));
    Future<void>.delayed(Duration(milliseconds: 500), () {
      _browseAnController.forward();
    });  }

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
        onChanged: (s) {
            if (_bodyState){
              _searchAnController.animateBack(0, curve: Curves.linear, duration: Duration(milliseconds: 500));
              Future<void>.delayed(Duration(milliseconds: 500), () {
                _browseAnController.forward();
              });
            } else {
              _browseAnController.animateBack(0, curve: Curves.linear, duration: Duration(milliseconds: 500));
              Future<void>.delayed(Duration(milliseconds: 500), () {
                _searchAnController.forward();
              });
            }
            Future<void>.delayed(Duration(milliseconds: 500), () {
              setState(() {
                _bodyState = !_bodyState;
              });
            });

        },
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

  Widget _searchOrganizations() {
    return ListView.builder(

      scrollDirection: Axis.vertical,
      itemCount: 10,
      itemBuilder: (context, i){
        return Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child:OrgCard(_orgImages[0], _orgNames[0]),
            ),
            Container(
              margin: EdgeInsets.only(right:10),
              child:OrgCard(_orgImages[0], _orgNames[0]),
            ),

          ],
        );
      },
    );
  }

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
                                context,
                              ),
                            ),
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
                  left: 20,
                  child: CatTitle(_orgCategories[rowindex]),
                )
              ],
            ),
          );
        }
      );
  }

  Widget _mainBody() {
    return Expanded(
      child: Container(
        child: _mainBodyContent(),
      ),
    );
  }

  Widget _mainBodyContent() {
    if (_bodyState) {
      return SlideTransition(
        position: _searchAn,
        child: _searchOrganizations(),
      );
    }
    return SlideTransition(
      position: _browseAn,
      child: _organizationList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: CustomPaint(
          painter: SearchPaint(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                _searchBar(),
                _mainBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _searchAnController.dispose();
    _browseAnController.dispose();
    super.dispose();
  }
}

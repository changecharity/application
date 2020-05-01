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

class Search extends StatefulWidget {
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
  bool _recentSearchOn = true;
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
    "https://images.shulcloud.com/1450/logo/1550604879.img",
    "http://www.jsn.info/uploads/1/9/1/2/19123279/published/1393271267.png?1513880506",
    "https://www.meiraacademy.org/uploads/1/9/1/2/19123279/download_orig.png",
    "https://www.torahanytime.com/static/images/logo.png",
    "https://www.boneiolam.org/images/bonei_olam_logo.jpg",
    "http://www.firstnonprofit.org/wp-content/uploads/2019/07/Olami-logo.jpg",
    "https://www.partnersintorah.org/wp-content/uploads/2017/12/partners-in-torah-white-logomark.png",
    "https://upload.wikimedia.org/wikipedia/en/a/a4/Zaka01.png"
  ];
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

  //var _searchedImages = _orgImages.contains(_searchedNames);
  //var _searchedNames =_orgNames.contains(searchController.text);
  var _orgCategories = [
    "Featured",
    "Recommended",
    "Ads",
    "Jewish Organizations"
  ];

  void showContainer() {
    if (_shouldSwitch) {
      _browseAnController.animateBack(0,
          curve: Curves.linear, duration: Duration(milliseconds: 500));
      Future<void>.delayed(Duration(milliseconds: 500), () {
        _searchAnController.forward();
      });
      Future<void>.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _bodyState = !_bodyState;
          _shouldSwitch = false;
        });
      });
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  void initState() {
    super.initState();
    _searchAnController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _browseAnController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900));

    _searchAn = Tween<Offset>(
      begin: Offset(0, 1.5),
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
    });
  }


  /*Widget _searchBar() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      width: MediaQuery.of(context).size.width / 1.15,
      height: MediaQuery.of(context).size.height / 14,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[350],
            blurRadius: 20.0,
            offset: Offset.fromDirection(0.9),
          ),
        ],
      ),

      child: TextField(
        onTap: showContainer,
        style: TextStyle(
          fontSize: 18,
        ),
        controller: searchController,
        onSubmitted: (text) {
          setState(() {
            _recentSearchOn = !_recentSearchOn;
          });
          print(text);
        },
        decoration: InputDecoration(
          prefixIcon: _switchSearchBack(),
          labelText: 'Search For Organizations',
          hasFloatingPlaceholder: false,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
            borderSide: BorderSide(
              style: BorderStyle.none,
            ),
          ),
        ),
      ),
      //onSubmitted: (s) => _getOrganizations(),
    );
  }*/

  Widget _switchSearchBack() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      switchInCurve: Curves.linear,
      switchOutCurve: Curves.linear,
      child: _shouldSwitch ? _searchIcon() : _backIcon(),
    );
  }

  Widget _searchIcon() {
    return Icon(
      Icons.search,
      color: Colors.black,
    );
  }

  Widget _backIcon() {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.black,
      onPressed: () {
        _searchAnController.animateBack(0,
            curve: Curves.linear, duration: Duration(milliseconds: 500));
        Future<void>.delayed(Duration(milliseconds: 500), () {
          _browseAnController.forward();
        });
        Future<void>.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _bodyState = !_bodyState;
            _shouldSwitch = true;
          });
        });
      },
    );
  }

  //made separate class for this so can implement in searchBar as well
  /*Widget _searchOrganizations() {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _orgNames.length,
        itemBuilder: (context, orgindex) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    'org$orgindex',
                    _orgImages[orgindex],
                    _orgNames[orgindex],
                    _orgSlogans[orgindex],
                    context,
                  ),
                ),
              );
            },
            child: SearchCard(
                _orgImages[orgindex],
                _orgNames[orgindex],
                _orgSlogans[orgindex],
                'org$orgindex',
            ),
          );
        },
      ),
    );
  }*/

  Widget _organizationList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _orgCategories.length,
      itemBuilder: (BuildContext context, int rowindex) {
        return Container(
          height: MediaQuery.of(context).size.height * .3,
          margin: rowindex == 0 ? EdgeInsets.only(top:20) : EdgeInsets.only(top:5),
          child: Column(
            children: <Widget>[
              Flexible(
               flex:1,
                child: CatTitle(_orgCategories[rowindex]),
              ),
              Flexible(
                flex: 6,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
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
                                _orgSlogans[orgindex],
                                context,
                              ),
                            ),
                          );
                        },
                        child: OrgCard(
                          _orgImages[orgindex],
                          _orgNames[orgindex],
                          '${rowindex}org$orgindex',
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          );
        }
      );
  }

  Widget _recentSearchList() {
    return Container(height: 100, width: 100, color: Colors.grey);
  }

  Widget _mainBody() {
    return Expanded(
      child: Container(
        child: _mainBodyContent(),
      ),
    );
  }

////review this
  Widget _mainBodyContent() {
    if (_bodyState) {
      return SlideTransition(
        position: _searchAn,
        child: _recentSearchOn ? _recentSearchList() : SearchedOrganizations(_orgNames, _orgImages, _orgSlogans),
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
               SearchBar2(),
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

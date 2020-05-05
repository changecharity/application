import 'package:flutter/material.dart';
import 'search.dart';
import 'searchedOrganizations.dart';

class SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _searchButton(context);
  }


  Widget _searchButton(BuildContext context){
      return Material(
          color: Colors.transparent,
          child: Center(
              child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 174, 229,1),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [BoxShadow(color:Colors.grey, offset:Offset(5.0,5.0), blurRadius:10.0)]
                  ),
                  child: IconButton(
                    padding:EdgeInsets.all(18),
                      color: Colors.white,
                      icon: Icon(Icons.search),
                      iconSize:25,
                      tooltip: 'Search',
                      onPressed: () {
                        showSearch(context:context, delegate:DataSearch());
                      }
                    )
              )
          )
      );

  }
}

class DataSearch extends SearchDelegate<String> {
  final organizations = [
    "Emek Beracha",
    "Jewish Study Network",
    "Meira Academy",
    "Torah Anytime",
    "Bonei Olam",
    "Olami",
    "Partners in Torah",
    "Zaka"
  ];
  final organizationImages=[
    NetworkImage("https://images.shulcloud.com/1450/logo/1550604879.img"),
    NetworkImage("http://www.jsn.info/uploads/1/9/1/2/19123279/published/1393271267.png?1513880506"),
    NetworkImage("https://www.meiraacademy.org/uploads/1/9/1/2/19123279/download_orig.png"),
    NetworkImage( "https://www.torahanytime.com/static/images/logo.png"),
    NetworkImage("https://www.boneiolam.org/images/bonei_olam_logo.jpg"),
    NetworkImage("http://www.firstnonprofit.org/wp-content/uploads/2019/07/Olami-logo.jpg"),
    NetworkImage("https://www.partnersintorah.org/wp-content/uploads/2017/12/partners-in-torah-white-logomark.png"),
    NetworkImage("https://upload.wikimedia.org/wikipedia/en/a/a4/Zaka01.png")
  ];
  final organizationSlogans=[
    "An Orthodox shul for everyone",
    "Raising the level of Jewish Literacy",
    "Empowering young Jewish Women",
    "More than 7,500,000 hours of Torah a year is being learned through TorahAnytime",
    "Creating Families. Building Eternity.",
    "Inspiring Jewish Greatness",
    "Jewish Journeys, custom made...",
    "Being ready for whatever tomorrow brings"
  ];

  final recentOrganizations = [
    "Emek Beracha",
    "Jewish Study Network",
    "Meira Academy"
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchedOrganizations(organizations, organizationImages, organizationSlogans);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentOrganizations
        : organizations
            .where((p) => p.toUpperCase().startsWith(query.toUpperCase()))
            .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        onTap:(){
          showResults(context);
        },
        leading: Icon(Icons.access_time),
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style:
                  TextStyle(fontSize:16,color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: TextStyle(color: Colors.grey, fontWeight:FontWeight.normal),
                )
              ]),
        ),
      ),
    );
  }
}

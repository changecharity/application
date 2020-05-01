import 'package:flutter/material.dart';
import './search.dart';
import './searchedOrganizations.dart';

class SearchBar2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _searchBar(context);
  }

  Widget _searchBar(BuildContext context) {
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
        style: TextStyle(
          fontSize: 18,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
          ),
          labelText: 'Search Organizations',
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
        onTap: () {
          showSearch(context: context, delegate: DataSearch());
        },
      ),
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
    "https://images.shulcloud.com/1450/logo/1550604879.img",
    "http://www.jsn.info/uploads/1/9/1/2/19123279/published/1393271267.png?1513880506",
    "https://www.meiraacademy.org/uploads/1/9/1/2/19123279/download_orig.png",
    "https://www.torahanytime.com/static/images/logo.png",
    "https://www.boneiolam.org/images/bonei_olam_logo.jpg",
    "http://www.firstnonprofit.org/wp-content/uploads/2019/07/Olami-logo.jpg",
    "https://www.partnersintorah.org/wp-content/uploads/2017/12/partners-in-torah-white-logomark.png",
    "https://upload.wikimedia.org/wikipedia/en/a/a4/Zaka01.png"
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

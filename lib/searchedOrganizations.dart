import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './searchCard.dart';
import './details.dart';

class SearchedOrganizations extends StatelessWidget {
  final namesList;
  final imageList;
  final slogansList;

  SearchedOrganizations(this.namesList, this.imageList, this.slogansList);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _searchedOrganizations();
  }

  Widget _searchedOrganizations() {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: namesList.length,
        itemBuilder: (context, orgindex) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    'org$orgindex',
                    imageList[orgindex],
                    namesList[orgindex],
                    slogansList[orgindex],
                    context,
                  ),
                ),
              );
            },
            child: SearchCard(
              imageList[orgindex],
              namesList[orgindex],
              slogansList[orgindex],
              'org$orgindex',
            ),
          );
        },
      ),
    );
  }
}

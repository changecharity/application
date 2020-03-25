import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'details.dart';

class Search extends StatefulWidget{
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State <Search> {
  TextEditingController searchController;
  var _organizations = [[],[],[]];
  Widget _searchBar() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      width: MediaQuery
          .of(context)
          .size
          .width / 1.15,
      height: MediaQuery
          .of(context)
          .size
          .height / 14,
      child: TextField(
        style: TextStyle(
          fontSize: 18,
        ),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: _searchIcon(),
          labelText: 'Search For Organizations',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10),),
          ),
        ),
        onSubmitted: (s) => _getOrganizations(),
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
        _getOrganizations();
      },
    );
  }

  Widget _transactionHistoryContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 40),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/3.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: _scrollingList(),
      ),
    );
  }

  Widget _scrollingList(){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _organizations[0].length,
      itemBuilder: (BuildContext context, int i){
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
              }));
            },
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
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              children: <Widget>[
                _searchBar(),
                _transactionHistoryContainer(),
                _submit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getOrganizations() async {
    var content = 'dope';
    var _temp = [[],[],[]];
    var response = await http.post(_address(), body: content);
    var responseDecode = json.decode(response.body);
    print(response.body);
    // [["1","2"]["google.com", "gmail.com"]["hi","bye"]]
    for( var i = 0 ; i < responseDecode["imageurls"].length; i++) {
      _temp[0].add(responseDecode["ids"][i]);
      _temp[1].add(responseDecode["imageurls"][i]);
      _temp[2].add(responseDecode["descriptions"][i]);
    }
    setState(() {
      _organizations = _temp;
    });
  }

  String _address() {
    if (Platform.isAndroid)
      return 'http://10.0.2.2:8080/api/getorganizations';
    else
      return 'http://localhost:8080/api/getorganizations';
  }
}
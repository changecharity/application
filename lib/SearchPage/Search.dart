import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Pages/login.dart';
import '../SearchPage/details.dart';
import '../Components/changeOrgDialog.dart';


class Search extends StatefulWidget{
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search>{

  var suggestions=[];
  var suggestionOffset=0;
  var searchOffset=0;
  bool areSuggestions=false;
  bool extraDetails=false;
  var token;
  var orgs;
  final _searchController=new TextEditingController();
  String searchText;
  ScrollController _suggestionScrollController;
  ScrollController _searchScrollController;

  void initState(){
    super.initState();

    _confirmLogin();

    //handle scroll controllers
    _suggestionScrollController=ScrollController();
    _suggestionScrollController.addListener(_suggestionScrollListener);

    _searchScrollController=ScrollController();
    _searchScrollController.addListener(_searchScrollListener);

  }

  Widget _searchBar(){
    return Container(
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child:_searchText()),
        ],
      )
    );
  }



  Widget _searchText(){
    return Container(
      decoration: BoxDecoration(
        border:Border(bottom: BorderSide(color:Colors.grey[300], width:1))
      ),
      child:TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onChanged: (s){
          setState(() {
            _getSuggestions();
          });
        },
        onSubmitted: (s){
          searchText=_searchController.text;
          _searchOrgs();
        },
        decoration:InputDecoration(
            labelText:'Search',
            hasFloatingPlaceholder: false,
            prefixIcon: _backSearch(),
            suffixIcon: _clearSearch(),
        ),
        autofocus: true,
      )
    );
  }

  Widget _backSearch(){
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.grey[500],
      ),
      onPressed: (){
        Navigator.pop(context);
      },
      splashColor: Colors.transparent,
    );
  }

  Widget _clearSearch(){
    return IconButton(
      icon: Icon(
        Icons.clear,
        color: Colors.grey[500],
      ),
      onPressed:(){
        setState(() {
          _searchController.text='';
          _getSuggestions();
        });
      },
      splashColor: Colors.transparent,
    );
  }

  Widget _searchResults(){
    return !extraDetails?_suggestions():_searchedOrganizations();
  }

  Widget _suggestions(){
    return Expanded(
      child: !areSuggestions ? Container(color:Colors.transparent):
      ListView.builder(
        controller:_suggestionScrollController,
        itemCount: !areSuggestions? 1: suggestions.length,
        itemBuilder: (context, index){
          return !areSuggestions?Container(color:Colors.transparent):
          ListTile(
              leading:Icon(Icons.search),
              dense:true,
              //trailing:Icon(Icons.search),
              title: Text(suggestions[index]),
              onTap:(){
                searchText=suggestions[index];
                  _searchOrgs();
              }
          );
        }
      )
    );
  }

  Widget _searchedOrganizations() {
    return Expanded(
        child: Container(
            color: Colors.grey[100],
            child: ListView.builder(
                controller: _searchScrollController,
                scrollDirection: Axis.vertical,
                itemCount: orgs.length,
                itemBuilder: (context, orgIndex) {
                  return ListTile(
                      leading: Container(
                          height: 50,
                          width: 50,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "${orgs[orgIndex]["logo"]}"),
                          )
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text("${orgs[orgIndex]["name"]}"),
                      subtitle: Text("Insert Slogan Here"),
                      //isThreeLine: true,
                      onTap: () {
                        showDialog(context: context, builder: (context)=>ChangeOrgDialog(orgs[orgIndex]["id"]), barrierDismissible: true );
                      }
//                        Navigator.push(
//                            context, MaterialPageRoute(builder: (context) =>
//                            DetailScreen(
//                              'org$orgIndex',
//                              orgs[orgIndex]["id"],
//                              context,
//                            ),
//                        )
//                        );
//                      }

                  );
                })
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child:SafeArea(
        child:Column(
          children: <Widget>[
            _searchBar(),
            _searchResults()
          ],
        )
      )
    );
  }

 _confirmLogin() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('token');
    });
    if(token == null || token ==''){
      Navigator.push(context, MaterialPageRoute(builder:(context)=>Login()));
    }
 }

  _getSuggestions() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    token = preferences.getString('token');
    var content = '{"user_token":"$token", "name":"${_searchController.text}", "offset":$suggestionOffset}';
    var response = await http.post("https://api.changecharity.io/users/getnames", body:content);
    setState(() {
      suggestions=jsonDecode(response.body)["names"];
      if(suggestions == null||suggestions.length==0){
        areSuggestions=false;
      }else{
        areSuggestions=true;
      }
    });
    print(suggestions);
 }

 _searchOrgs() async{
   SharedPreferences preferences=await SharedPreferences.getInstance();
   token = preferences.getString('token');
   var content = '{"user_token":"$token", "name":"$searchText", "offset":$searchOffset}';
   var response = await http.post("https://api.changecharity.io/users/searchorgs", body:content);
   //Navigator.push(context, MaterialPageRoute(builder:(context)=>SearchedOrganizations(orgs)));
   setState(() {
     orgs=jsonDecode(response.body)["orgs"];
     extraDetails=true;
   });
   print(orgs);
 }

 _searchScrollListener(){
    if(_searchScrollController.offset>=_searchScrollController.position.maxScrollExtent &&
        !_searchScrollController.position.outOfRange){
      setState(() {
        searchOffset+=15;
        _searchOrgs();
      });
    }
 }

 _suggestionScrollListener(){
    if(_suggestionScrollController.offset>=_suggestionScrollController.position.maxScrollExtent &&
      !_suggestionScrollController.position.outOfRange){
      setState(() {
        suggestionOffset+=15;
        _getSuggestions();
      });
   }
 }
}

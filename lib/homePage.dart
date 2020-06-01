import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  //for date format
import 'package:intl/date_symbol_data_local.dart';  //for date locale
import 'package:money2/money2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:change/UserOrgModel.dart';

import 'profile.dart';
import 'paintings.dart';
import 'login.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  AnimationController _controller;
  AnimationController _paintController;
  Animation<Offset> _transactionAnimation;
  Animation<Offset> _currentAnimation;
  Animation<Offset>_textAnimation;
  Animation<Offset>_paintAnimation;
  ScrollController _scrollController;
  String token;
  String selectedOrg;
  String selectedOrgImg='https://wallpaperplay.com/walls/full/b/d/1/58065.jpg';
  int offset=0;
  var transactions;
  Money monthTotal;
  Money weekTotal;
  Currency usdCurrency=Currency.create('USD', 2);

  void initState() {
    super.initState();

    //handle getting info
    _confirmLogin();
    _getAllInfo();


    //handle animations
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _paintController=
      AnimationController(vsync:this, duration:Duration(milliseconds:1500));

    _transactionAnimation = Tween<Offset>(
      begin: Offset(0.0, 2.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
    ));

    _textAnimation=Tween<Offset>(
      begin: Offset(-1.0, 0),
      end:Offset(0,0)
    ).animate(CurvedAnimation(
      parent:_controller,
      curve:Curves.fastLinearToSlowEaseIn,
    ));

    _currentAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent:_controller,
      curve:Curves.fastLinearToSlowEaseIn,
    ));

    _paintAnimation=Tween<Offset>(
      begin:Offset(1, 0),
      end:Offset(0,0),
    ).animate(CurvedAnimation(
      parent:_paintController,
      curve:Curves.fastLinearToSlowEaseIn
    ));

    _paintController.forward();

    Future<void>.delayed(Duration(milliseconds:800),(){
      _controller.forward();
    });

    //handle scroll controller
    _scrollController=ScrollController();
    _scrollController.addListener(_scrollListener);


  }

  Widget _accountIcon(){
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10),
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder:(context)=>Profile()));
        },
        icon: Icon(Icons.perm_identity),
        iconSize:32,
        color:Colors.black,
        splashColor:Colors.grey,
      )
    );
  }

  Widget _currentInfo() {
    return Container(
      padding:EdgeInsets.all(15),
      margin:EdgeInsets.only(bottom:10, top:15),
      width: MediaQuery.of(context).size.width * .75,
      decoration:BoxDecoration(
        color:Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color:Colors.grey[300], offset:Offset.fromDirection(1), blurRadius:15)]
      ),
      child:Column(
        children: <Widget>[
          Consumer<UserOrgModel>(
            builder:(context, userOrg, child){
              return Text(
                '${userOrg.getUserOrg}',
                style:TextStyle(color:Colors.black, fontSize:18, fontWeight: FontWeight.bold),
              );
            }
          ),
          Consumer<UserOrgModel>(
              builder:(context, userOrg, child){
                return Container(
                  margin:EdgeInsets.only(top:20),
                  height:100,
                  width:100,
                  decoration: BoxDecoration(
                    image:DecorationImage(
                      image: NetworkImage('${userOrg.getOrgImg}'),
                      fit: BoxFit.cover,
                    ),
                    shape:BoxShape.circle,
                  ),
                );
              }
          ),
          Container(
            margin:EdgeInsets.only(top:20),
            child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    '$monthTotal',
                    style:TextStyle(color:Color.fromRGBO(0, 174, 229, 1), fontWeight: FontWeight.bold, fontSize:16)
                  ),
                  Text(
                    'Month to date',
                    style:TextStyle(color:Colors.black)
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                      '$weekTotal',
                      style:TextStyle(color:Color.fromRGBO(0, 174, 229, 1), fontWeight: FontWeight.bold, fontSize:16)
                  ),
                  Text(
                      'Week to date',
                      style:TextStyle(color:Colors.black)
                  )
                ],
              ),
            ],
          ),
          )
        ],
      )


    );
  }

  Widget _transactionText(){
    return Container(
      margin:EdgeInsets.only(bottom:10, left:10),
      alignment:Alignment.centerLeft,
      child:Text(
        'Transactions',
        style: TextStyle(fontSize:16, color:Colors.grey)
      )
    );
  }

  Widget _transactionHistory() {
    return Container(
        height: MediaQuery.of(context).size.height * .45,
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [BoxShadow(color:Colors.grey[300], offset:Offset.fromDirection(5, 7), blurRadius: 10)]
        ),
      child:_transactionsList()
    );
  }

  Widget _transactionsList(){
    if(transactions==''|| transactions==null){
     return Container(
       width: MediaQuery.of(context).size.width,
       height: MediaQuery.of(context).size.height * .45,
       alignment: Alignment.center,
       child:Text(
           'You have no transactions at this time.'
       )
     );
    }
    return ListView.separated(
      controller: _scrollController,
      separatorBuilder: (context, i){
      return Divider(
        color:Colors.black,
        endIndent:10,
        indent:10,
        );
      },
      itemCount:transactions.length,
      itemBuilder: (context, i){
        return Container(
          padding:EdgeInsets.symmetric(vertical:10),
          child:Row(
            children: <Widget>[
              Container(
                height:50,
                width:50,
                decoration:BoxDecoration(
                  color:Color.fromRGBO(0, 174, 229, .6),
                  shape:BoxShape.circle,
                ),
                child:Center(
                  child:Text(
                    '${transactions[i]["name"].toString().substring(0,1)}',
                    style:TextStyle(fontSize:20, fontWeight: FontWeight.bold, color:Colors.white)
                  )
                )
              ),
              Expanded(
                //margin:EdgeInsets.only(left:20),
                child:Container(
                  margin:EdgeInsets.only(left:20, right:20),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment:MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                //width: MediaQuery.of(context).size.width*.4,
                                child:Text(
                                  transactions[i]["name"].length<10?'${transactions[i]["name"]}':transactions[i]["amount"].toStringAsFixed(2).length>5?'${transactions[i]["name"].toString().substring(0,6)}...':'${transactions[i]["name"].toString().substring(0,10)}...',
                                  style:TextStyle(fontSize: 16, color: Colors.black, ),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ),
                              Text(
                                  '  \$${(transactions[i]["amount"]).toStringAsFixed(2)}',
                                  style:TextStyle(fontSize: 16, color: Colors.black, )
                              ),
                            ],
                          ),
                          Text(
                            '${transactions[i]["dot"]}',
                            style:TextStyle(color: Colors.grey[700])
                          )
                        ],
                      ),
                      Container(
                        child: Text(
                          '+${transactions[i]["change"]}\u{00A2}',
                          style: TextStyle(color:Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      )
                    ],
                  )
                )
              ),
            ],
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        //child:SingleChildScrollView(
          child:Container(
          height:MediaQuery.of(context).size.height,
            child:SlideTransition(
              position:_paintAnimation,
              child:CustomPaint(
                painter:Home2Paint(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SlideTransition(position:_textAnimation, child:_accountIcon()),
                        SlideTransition(position: _currentAnimation, child: _currentInfo()),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SlideTransition(position:_textAnimation, child:_transactionText()),
                        SlideTransition(position: _transactionAnimation, child: _transactionHistory()),
                      ],
                    ),
                  ],
                )
              )
            )
          )
        //)
      ),
      extendBody: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _paintController.dispose();
    super.dispose();
  }

  _scrollListener(){
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        offset+=15;
        _getMoreTransactions();
      });
    }
  }

  _getMoreTransactions() async{
    var transContent='{"user_token":"$token", "offset":$offset}';
    var transactionResponse = await http.post("https://changecharity.io/api/users/gettransactions", body:transContent);
    setState(() {
      transactions+=jsonDecode(transactionResponse.body)["transactions"];
    });
    print(transactions);
    print(transactions.length);
  }

  //get all initial user info
  //get token and make sure it's not null
  _confirmLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
    print(token);
    if(token == null || token ==''){
      Navigator.push(context, MaterialPageRoute(builder:(context)=>Login()));
    }
  }

  //get user's transactions
  _getTransactions() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var transContent='{"user_token":"$token", "offset":$offset}';
    var transactionResponse = await http.post("https://changecharity.io/api/users/gettransactions", body:transContent);
    setState(() {
      transactions=jsonDecode(transactionResponse.body)["transactions"];
    });
    print(transactions);
    print(transactions.length);
  }

  //get user's totals
  _getTotals() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var totalContent='{"user_token":"$token"}';
    var totalResponse = await http.post("https://changecharity.io/api/users/getuserstotals", body:totalContent);
    setState(() {
      jsonDecode(totalResponse.body)["monthlyTotal"]==null?monthTotal=Money.fromInt(0, usdCurrency):monthTotal=Money.fromInt(int.parse(jsonDecode(totalResponse.body)["monthlyTotal"]), usdCurrency);
      jsonDecode(totalResponse.body)["weeklyTotal"]==null?weekTotal=Money.fromInt(0, usdCurrency):weekTotal=Money.fromInt(int.parse(jsonDecode(totalResponse.body)["monthlyTotal"]), usdCurrency);
    });
    print(monthTotal);
    print(weekTotal);
  }

  //get and save user's org info
  _getOrgInfo() async{

    //get user's org info
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var orgContent='{"user_token":"$token"}';
    var orgResponse = await http.post("https://changecharity.io/api/users/getusersorginfo", body:orgContent);
    setState(() {
      selectedOrg=jsonDecode(orgResponse.body)["name"];
      selectedOrgImg=jsonDecode(orgResponse.body)["logoLocation"];
    });
    print(selectedOrg);

    //set org name and org image in provider
    context.read<UserOrgModel>().notify(selectedOrg, selectedOrgImg);
  }

  _getAllInfo() async{
    _getTransactions();
    _getTotals();
    _getOrgInfo();
  }
}


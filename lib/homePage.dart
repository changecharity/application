import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  //for date format
import 'package:intl/date_symbol_data_local.dart';  //for date locale

import 'profile.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation<Offset> _transactionAnimation;
  Animation<Offset> _currentAnimation;
  Animation<Offset>_textAnimation;

  var Transactions=[
    ["Target", 51.45, DateTime(2020, 5, 1)],
    ["Safeway", 120.25, DateTime(2020, 5, 2)],
    ["Baskin Robbins", 5.46, DateTime(2020, 5, 2)],
    ["Target", 51.35, DateTime(2020, 5, 2)],
    ["Safeway", 120.45, DateTime(2020, 5, 2)],
    ["Baskin Robbins", 5.45, DateTime(2020, 5, 2)],
    ["Target", 51.27, DateTime(2020, 5, 2)],
    ["Safeway", 120.45, DateTime(2020, 5, 2)],
    ["Baskin Robbins", 5.87, DateTime(2020, 5, 2)]
  ];

  String changeAmount(amountSpent){
    return (double.parse(amountSpent.toString()).truncate()+1-double.parse(amountSpent.toString())).toStringAsFixed(2);
  }


  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _transactionAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn
    ));

    _textAnimation=Tween<Offset>(
      begin: Offset(-1.0, 0),
      end:Offset(0,0)
    ).animate(CurvedAnimation(
      parent:_controller,
      curve:Curves.fastLinearToSlowEaseIn
    ));

    _currentAnimation = Tween<Offset>(
      begin: Offset(0, -1.0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent:_controller,
      curve:Curves.fastLinearToSlowEaseIn
    ));

   _controller.forward();

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
        color:Colors.grey,
        splashColor:Colors.grey,


      )
    );
  }
  Widget _currentInfo() {
    return Container(
      padding:EdgeInsets.all(15),
      margin:EdgeInsets.only(bottom:30),
      width: MediaQuery.of(context).size.width * .75,
      decoration:BoxDecoration(
        color:Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color:Colors.grey[300], offset:Offset.fromDirection(1), blurRadius:15)]
      ),
      child:Column(
        children: <Widget>[
          Text(
            'Partners in Torah',
            style:TextStyle(color:Colors.lightBlueAccent[100], fontSize:18, fontWeight: FontWeight.bold),
          ),
          Container(
            margin:EdgeInsets.only(top:20),
            height:100,
            width:100,
            decoration: BoxDecoration(
              color:Colors.grey[300],
              shape:BoxShape.circle,
            ),
          ),
          Container(
            margin:EdgeInsets.only(top:20),
            child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    '\$55.89',
                    style:TextStyle(color:Colors.lightBlueAccent[100], fontWeight: FontWeight.bold, fontSize:16)
                  ),
                  Text(
                    'Month to date',
                    style:TextStyle(color:Colors.grey)
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                      '\$24.32',
                      style:TextStyle(color:Colors.lightBlueAccent[100], fontWeight: FontWeight.bold, fontSize:16)
                  ),
                  Text(
                      'Week to date',
                      style:TextStyle(color:Colors.grey)
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
    return ListView.separated(
      separatorBuilder: (context, i){
        return Divider(
          color:Colors.grey,
          //thickness:1.0,
          endIndent:10,
          indent:10,
        );
      },
      itemCount:Transactions.length,
      itemBuilder: (context, i){
        return Container(
          padding:EdgeInsets.symmetric(vertical:10),
          child:Row(
            children: <Widget>[
              Container(
                height:50,
                width:50,
                decoration:BoxDecoration(
                  border:Border.all(color:Colors.lightBlue[100*i+100], width:3),
                  shape:BoxShape.circle,
                ),
                child:Center(
                  child:Text(
                    '${Transactions[i][0].toString().substring(0,1)}',
                    style:TextStyle(fontSize:20, fontWeight: FontWeight.bold, color:Colors.lightBlue[100*i+100])
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
                          Text(
                            '${Transactions[i][0]}  \$${Transactions[i][1]}',
                            style:TextStyle(fontSize: 16, color: Colors.grey[700], )
                          ),
                          Text(
                            '${DateFormat.yMMMMd().format(Transactions[i][2])}',
                            style:TextStyle(color: Colors.grey)
                          )
                        ],
                      ),
                      Container(
                        child: Text(
                          '+${changeAmount(Transactions[i][1])}',
                          style: TextStyle(color:Colors.grey[700], fontSize: 20, fontWeight: FontWeight.bold),
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
        child:SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SlideTransition(position:_textAnimation, child:_accountIcon()),
                SlideTransition(position: _currentAnimation, child: _currentInfo()),
                Column(
                  children: <Widget>[
                    SlideTransition(position:_textAnimation, child:_transactionText()),
                    SlideTransition(position: _transactionAnimation, child: _transactionHistory()),
                  ],
                ),
              ],
            )
        )
      ),
      extendBody: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

import 'dart:convert';
import 'package:change/Models/userProfileModel.dart';
import 'package:change/Pages/linkBank.dart';
import 'package:change/Pages/linkCredit.dart';
import 'package:change_charity_components/change_charity_components.dart';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:change/Models/userOrgModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:global_configuration/global_configuration.dart';

import 'Search.dart';
import 'newPofile.dart';
import 'login.dart';
import '../Models/userBankModel.dart';


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
  int offset;
  var transactions;
  Money monthTotal;
  Money weekTotal;
  Currency usdCurrency=Currency.create('USD', 2);
  GlobalConfiguration cfg = new GlobalConfiguration();
  bool isError = false;

  void initState() {
    super.initState();

    //handle getting info
    _confirmLogin();
    offset=0;
    _checkSelOrg();
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
      begin: Offset(-1.3, 0),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20, left: 20),
          alignment: Alignment.centerLeft,
          child: Container(
            width: 50,
            height: 50,
            child: RaisedButton(
              color: Color.fromRGBO(0, 174, 229, 1),
              onPressed: ()async{
                _controller.animateBack(0, duration: Duration(milliseconds: 800));
                await _paintController.animateBack(0,duration: Duration(milliseconds: 1000));
                Future<void>.delayed(Duration(milliseconds: 100), (){
                  Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewProfile()));
                });
              },
              child: Consumer<UserProfileModel>(
                builder: (context, userPF, child){
                  return Text(
                    userPF.getUserPfLetter,
                    style:TextStyle(fontSize: 24, color:Colors.white, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
          ),
        ),
        _errorButton()
      ],
    );
  }

  Widget _errorButton() {
    if(isError) {
      return  Container(
        margin: EdgeInsets.only(top: 20, right: 20),
        alignment: Alignment.centerRight,
        child: Container(
          width: 50,
          height: 50,
          child: RaisedButton(
              color: Colors.red[600],
              onPressed: ()async{
                _controller.animateBack(0, duration: Duration(milliseconds: 800));
                await _paintController.animateBack(0,duration: Duration(milliseconds: 800));
                Future<void>.delayed(Duration(milliseconds: 30), (){
                  Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewProfile()));
                });
              },
              child: Transform.scale(
                scale: 1.4,
                child: Icon(
                  Icons.error_outline,
                  size: 18,
                ),
              )
          ),
        ),
      );
    }
    return Container();
  }


  Widget _currentInfo() {
    return Container(
      padding:EdgeInsets.all(15),
      margin:EdgeInsets.only(bottom:10, top:15),
      width: MediaQuery.of(context).size.width * .75,
      decoration:BoxDecoration(
        color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey[100] : Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey[300] : Colors.grey[600],
            offset:Offset.fromDirection(1),
            blurRadius:15),
        ],
      ),
      child:Column(
        children: <Widget>[
          Consumer<UserOrgModel>(
            builder:(context, userOrg, child){
              return GestureDetector(
                onTap: (){
                  if (userOrg.getUserOrg == "Choose Your Org"){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>Search()));
                  }
                },
                child: Text(
                  '${userOrg.getUserOrg}',
                  style:TextStyle(fontSize:18, fontWeight: FontWeight.bold),
                ),
              );
            }
          ),
          Consumer<UserOrgModel>(
              builder:(context, userOrg, child){
                return Container(
                  margin:EdgeInsets.only(top:20),
                  height:100,
                  width:100,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: userOrg.getOrgImg,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => RaisedButton(
                        color: Color.fromRGBO(0, 174, 229, 1),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(context)=>Search())),
                        elevation: 0,
                        child: Icon(
                          Icons.search,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
        height: MediaQuery.of(context).size.height > 700 ? MediaQuery.of(context).size.height * .45 : MediaQuery.of(context).size.height < 650 ? 210 : MediaQuery.of(context).size.height * .40,
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: BoxDecoration(
          color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey[100] : Colors.grey[900],
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [BoxShadow(
              color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey[300] : Colors.grey[700],
              offset:Offset.fromDirection(5, 7),
              blurRadius: 10),
          ]
        ),
      child:_transactionsList()
    );
  }

  Widget _transactionsList(){
    if(transactions==''|| transactions==null){
     return GestureDetector(
       onTap: () {
         _transactionsContTextClick();
       },
       child: Container(
         width: MediaQuery.of(context).size.width,
         height: MediaQuery.of(context).size.height * .42,
         alignment: Alignment.center,
         child:Text(
           _transactionsContText(),
           textAlign: TextAlign.center,
         )
       ),
     );
    }
    return ListView.separated(
      controller: _scrollController,
      separatorBuilder: (context, i){
      return Divider(
        color:MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white,
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
                  color:Color.fromRGBO(0, 174, 229, MediaQuery.of(context).platformBrightness == Brightness.light ? .6 : 1),
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
                                  style:TextStyle(fontSize: 16, ),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ),
                              Text(
                                  '  \$${(transactions[i]["amount"]).toStringAsFixed(2)}',
                                  style:TextStyle(fontSize: 16, )
                              ),
                            ],
                          ),
                          Text(
                            '${transactions[i]["dot"]}',
                            style:TextStyle(color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey[700] : Colors.grey[500])
                          )
                        ],
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              '${transactions[i]["change"]}',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                '\u{00A2}',
                                style: TextStyle(color:Color.fromRGBO(0, 174, 229, 0.9), fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
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
    final bool isLight =  MediaQuery.of(context).platformBrightness == Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isLight ? Colors.grey[100] : Colors.grey[900],
      systemNavigationBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
      statusBarBrightness: isLight ? Brightness.dark : Brightness.light,
    ));
    return Material(
      child: SafeArea(
        //child:SingleChildScrollView(
          child:Container(
          height:MediaQuery.of(context).size.height,
            child:SlideTransition(
              position:_paintAnimation,
              child:CustomPaint(
                painter:ChangeHomePaint(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SlideTransition(position:_currentAnimation, child:_accountIcon()),
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
        _getTransactions();
      });
    }
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Login()));
    }
  }

  _checkSelOrg() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int org = prefs.getInt("selOrg");
    token = prefs.getString('token');
    if (org != null) {
      print("org selected is ${org.toString()}");
      var content = '{"user_token":"$token", "org":$org}';
      var response = await http.post("${cfg.getString("host")}/users/setorg", body:content);
      print(response.body);
      await _getOrgInfo();
      prefs.setInt('selOrg', null);
      _showDialog();
    }
  }

  //get user's transactions
  _getTransactions() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var transContent='{"user_token":"$token", "offset":$offset}';
    var transactionResponse = await http.post("${cfg.getString("host")}/users/gettransactions", body:transContent);
    if (transactionResponse.body.contains("no rows in result set")) {
      prefs.setString('token', null);
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Login()));
    }
    var transDecoded = jsonDecode(transactionResponse.body)["transactions"];
    if(transDecoded != null){
      if(offset==0){
        setState(() {
          transactions = jsonDecode(transactionResponse.body)["transactions"];
        });
      //on scroll, get additional transactions
      }else{
        setState(() {
          transactions += jsonDecode(transactionResponse.body)["transactions"];
        });
      }
      print(transactions);
      print(transactions.length);
    }
  }

  //get user's totals
  _getTotals() async{
    setState(() {
      monthTotal=Money.fromInt(0, usdCurrency);
      weekTotal=Money.fromInt(0, usdCurrency);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var totalContent='{"user_token":"$token"}';
    var totalResponse = await http.post("${cfg.getString("host")}/users/getuserstotals", body:totalContent);
    setState(() {
      jsonDecode(totalResponse.body)["monthlyTotal"]==null?monthTotal=Money.fromInt(0, usdCurrency):monthTotal=Money.fromInt(int.parse(jsonDecode(totalResponse.body)["monthlyTotal"]), usdCurrency);
      jsonDecode(totalResponse.body)["weeklyTotal"]==null?weekTotal=Money.fromInt(0, usdCurrency):weekTotal=Money.fromInt(int.parse(jsonDecode(totalResponse.body)["weeklyTotal"]), usdCurrency);
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
    var orgResponse = await http.post("${cfg.getString("host")}/users/getusersorginfo", body:orgContent);
    print(orgResponse.body);
    if(orgResponse.body.contains("no rows in result")) {
      setState(() {
        selectedOrg="Choose Your Org";
        selectedOrgImg="error";
      });
    } else {
      setState(() {
        selectedOrg=jsonDecode(orgResponse.body)["name"];
        selectedOrgImg=jsonDecode(orgResponse.body)["logoLocation"];
      });
    }
    //set org name and org image in provider
    context.read<UserOrgModel>().notify(selectedOrg, selectedOrgImg);
  }

  //call at initState to get user's max threshold, last 4 digits, and bank name
  _getProfDetails() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var content='{"user_token":"$token"}';
    var profileResponse = await http.post("${cfg.getString("host")}/users/getprofile", body:content);
    var decodedRes =  jsonDecode(profileResponse.body);
    var decodedMask = decodedRes["mask"].toString();
    var decodedPL = decodedRes["legalName"];
    var mask = decodedMask == null ? "0000" : decodedMask;
    var threshDecode = decodedRes["threshold"];
    var bankName=decodedRes["bankName"];
    var profileLetter = decodedPL != null ? decodedPL[0] : "A";
    List cards = decodedRes["cards"];
    var monthlyLimit = decodedRes["monthlyLimit"];
    var roundUps = decodedRes["roundUpStatus"] == null ? false : true;
    //notify provider of mask and bankName

    context.read<UserBankModel>().notify(mask, bankName, cards);
    context.read<UserProfileModel>().notify(profileLetter, decodedPL, threshDecode, monthlyLimit, roundUps);
  }

  _getAllInfo() async{
    _getTransactions();
    _getTotals();
    _getOrgInfo();
    _getProfDetails();
  }

  String _transactionsContText() {
    if (context
        .watch<UserBankModel>()
        .getBankName == "" || context
        .watch<UserBankModel>()
        .getBankName == null) {
      return "You must link a payment method to begin donating.";
    } else if (context
        .watch<UserBankModel>()
        .getCards.length == 0) {
      return "You must link a round-up method in the accounts overview page";
    } else {
      return 'You have no transactions at this time. Check back in a few days';
    }
  }

  void _transactionsContTextClick() {
    if (context
        .read<UserBankModel>()
        .getBankName == "" || context
        .read<UserBankModel>()
        .getBankName == null) {
      Future<void>.delayed(Duration(milliseconds: 100), () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LinkCredit()));
      });
    } else if (context
        .read<UserBankModel>()
        .getCards.length == 0) {
      Future<void>.delayed(Duration(milliseconds: 100), () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LinkBank()));
      });
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          title: Align(
            alignment: Alignment.center,
            child: Text(
              "Organization Selected",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          content: Container(
            height: 100,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  Text(
                    "You have selected:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Expanded(
                    child: Text(
                      "${context.watch<UserOrgModel>().getUserOrg}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
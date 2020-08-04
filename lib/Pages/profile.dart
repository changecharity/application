import 'dart:convert';
import 'dart:async';

import 'package:change_charity_components/change_charity_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Search.dart';
import '../Models/userOrgModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'homePage.dart';
import 'login.dart';
import '../Components/passwordDialog.dart';
import '../Models/userBankModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:money2/money2.dart';
import '../Components/aboutDialog.dart';
import '../Components/bankAccountsDialog.dart';

class Profile extends StatefulWidget{

  @override
  _ProfileState createState()=>_ProfileState();
}

enum MenuOptions { signOut, contact, about }

class _ProfileState extends State<Profile> with TickerProviderStateMixin {

  AnimationController _controller;
  AnimationController _sliderController;
  Animation<Offset> _topDown;
  Animation<Offset> _bottomUp;
  Animation<Offset>_rightToLeft;
  ColorTween _colorTween;
  Animation<Color> _sliderAnimation;

  Currency usdCurrency = Currency.create('USD', 2);
  String token;
  var threshold = 100;
  String mask;
  String bankName;
  bool sliderChanging = false;
  var _widgetIndex = 0;
  var profileLetter = '';
  bool showMenu = false;
  var password;

  bool _switchVal = false;
  int _monthLimit;
  Money _monthLimitMoney;
  int _initialSliderVal = 3000;

  GlobalConfiguration cfg = new GlobalConfiguration();

  String selectedOrg;
  String selectedOrgImg = 'https://wallpaperplay.com/walls/full/b/d/1/58065.jpg';

  void initState() {
    super.initState();

    _confirmLogin();
    _getInitInfo();

    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _sliderController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _topDown = Tween<Offset>(
      begin: Offset(-1.0, -2.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn
    )
    );

    _bottomUp = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn
    )
    );

    _rightToLeft = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    )
    );

    _colorTween = ColorTween(
      begin: Colors.red[600],
      end: Color.fromRGBO(0, 174, 229, 1),
    );

    _sliderAnimation = _colorTween.animate(_sliderController);

    Future<void>.delayed(Duration(milliseconds: 100), () {
      _controller.forward();
    });
  }

  Widget _backButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10),
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        iconSize: 30,
        onPressed: () {
          _returnHome();
        },
      ),
    );
  }

  Widget _menuIcon() {
    return Container(
        margin: EdgeInsets.only(top: 20, right: 10),
        alignment: Alignment.centerRight,
        child: PopupMenuButton<MenuOptions>(
          color: MediaQuery
              .of(context)
              .platformBrightness == Brightness.light
              ? Colors.grey[100]
              : Colors.grey[900],
          icon: Icon(Icons.more_vert, size: 30),
          onSelected: (MenuOptions result) {
            switch (result.index) {
              case 0 :
                _logout();
                break;
              case 1 :
                _contactUs();
                break;
              case 2 :
                showDialog(context: context,
                    builder: (context) =>
                        AboutChange(),
                    barrierDismissible: true);
                break;
            }
          },
          itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<MenuOptions>>[
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.signOut,
              child: Text('Sign Out'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.contact,
              child: Text('Contact Us'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.about,
              child: Text('About Change'),
            ),
          ],
        )
    );
  }


  Widget _accountContainer() {
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 1,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _backButton(),
                _menuIcon()
              ],
            ),
            Container(
                margin: EdgeInsets.only(bottom: 10, top: MediaQuery
                    .of(context)
                    .size
                    .height < 700 ? 0 : MediaQuery
                    .of(context)
                    .size
                    .height * 0.1),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 174, 229, 1),
                  shape: BoxShape.circle,
                ),
                child: Align(
                    alignment: Alignment.center,
                    child: Consumer<UserBankModel>(
                        builder: (context, userBank, child) {
                          return Text(
                            userBank.getPfLetter.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold
                            ),
                          );
                        }
                    )
                )
            ),
            Text(
              'My Profile',
              style: TextStyle(fontSize: 50),
            ),
          ],
        )
    );
  }

  Widget _accountPrefs() {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery
          .of(context)
          .size
          .height < 700 ? MediaQuery
          .of(context)
          .size
          .height * 0.07 : MediaQuery
          .of(context)
          .size
          .height * 0.09),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 10, left: 10, top: 15),
              child: Text(
                  'Preferences',
                  style: TextStyle(fontSize: 16, color: Colors.grey)
              )
          ),
          Container(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              width: MediaQuery
                  .of(context)
                  .size
                  .width * .75,
              //height:MediaQuery.of(context).size.height*.4,
              decoration: BoxDecoration(
                  color: MediaQuery
                      .of(context)
                      .platformBrightness == Brightness.light
                      ? Colors.grey[100]
                      : Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(
                      color: MediaQuery
                          .of(context)
                          .platformBrightness == Brightness.light ? Colors
                          .grey[300] : Colors.grey[700],
                      offset: Offset.fromDirection(1),
                      blurRadius: 15),
                  ]
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _widgetIndex != 0 ? IconButton(
                            icon: Icon(Icons.arrow_back_ios, size: 16),
                            splashColor: MediaQuery
                                .of(context)
                                .platformBrightness == Brightness.light ? Colors
                                .grey[100] : Colors.grey[900],
                            highlightColor: MediaQuery
                                .of(context)
                                .platformBrightness == Brightness.light ? Colors
                                .grey[100] : Colors.grey[900],
                            onPressed: () {
                              setState(() {
                                _widgetIndex--;
                              });
                            }
                        ) : IconButton(onPressed: () {},
                            icon: Icon(Icons.arrow_back_ios, size: 16,
                                color: Colors.transparent)),
                        Expanded(
                            child: IndexedStack(
                                index: _widgetIndex,
                                children: <Widget>[
                                  Center(child: Text('Current Organization',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.bold))),
                                  Center(child: Text('Your Bank Account',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.bold))),
                                  Center(child: Text('Set Your Max',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.bold))),
                                  Center(child: Text('Set Your Monthly Limit',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.bold))),
                                ]
                            )
                        ),
                        _widgetIndex != 3 ? IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            iconSize: 16,
                            splashColor: MediaQuery
                                .of(context)
                                .platformBrightness == Brightness.light ? Colors
                                .grey[100] : Colors.grey[900],
                            highlightColor: MediaQuery
                                .of(context)
                                .platformBrightness == Brightness.light ? Colors
                                .grey[100] : Colors.grey[900],
                            onPressed: () {
                              setState(() {
                                _widgetIndex++;
                              });
                            }
                        ) : IconButton(onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios, size: 16,
                                color: Colors.transparent)),
                      ],
                    ),
                    IndexedStack(
                      index: _widgetIndex,
                      children: <Widget>[
                        _currentOrgContent(),
                        _bankContent(),
                        _sliderContent(),
                        _monthlyLimitContent()
                      ],
                    ),
                  ]
              )
          )
        ],
      ),
    );
  }

  Widget _bankContent() {
    return Container(
        alignment: Alignment.center,
        child: Consumer<UserBankModel>(
            builder: (context, userBank, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (userBank.getBankName == null) {
                        showDialog(context: context,
                            builder: (context) => PasswordDialog("change"),
                            barrierDismissible: true);
                      } else {
                        Navigator.of(context).push(new MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                              return BankAccountsDialog();
                            },
                            fullscreenDialog: true
                        ));
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 174, 229, 1),
                            borderRadius: BorderRadius.circular(100)
                        ),
                        child: Center(
                            child: Icon(
                                Icons.business,
                                size: 75,
                                color: Colors.white
                            )
                        )
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10, bottom: 15),
                      //if bank is unlinked, show no linked account. else, show info
                      child: userBank.getBankName == null ?
                      Text(
                          'No Linked Account',
                          style: TextStyle(
                              color: Color.fromRGBO(0, 174, 229, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold)
                      ) :
                      Text(
                          '${userBank.getBankName}(...${userBank.getMask !=
                              "null" ? '${userBank.getMask}' : '0000'})',
                          style: TextStyle(
                              color: Color.fromRGBO(0, 174, 229, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold)
                      )
                  ),
                  //if bank is unlinked, option to link account. otherwise, option to unlink or change
                  userBank.getBankName == null ?
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                          ),
                          text: "Link Account",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showDialog(context: context,
                                  builder: (context) =>
                                      PasswordDialog("change"),
                                  barrierDismissible: true);
                            }
                      )
                  ) :
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  color: MediaQuery
                                      .of(context)
                                      .platformBrightness == Brightness.light
                                      ? Colors.grey[700]
                                      : Colors.grey[200],
                                  fontSize: 12,
                                  fontFamily: 'Montserrat',
                                  decoration: TextDecoration.underline,
                                ),
                                text: "Manage Accounts",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                                        builder: (BuildContext context) {
                                          return BankAccountsDialog();
                                        },
                                        fullscreenDialog: true
                                    ));
                                  }
                            )
                        ),
                      ]
                  )
                ],
              );
            }
        )
    );
  }

  Widget _currentOrgContent() {
    return Container(
      alignment: Alignment.center,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                _currentOrgImg(),
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: _currentOrgText()
                )
              ],
            ),
            Container(
                child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: MediaQuery
                              .of(context)
                              .platformBrightness == Brightness.light ? Colors
                              .grey[700] : Colors.grey[200],
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                        ),
                        text: "Change Organization",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Search()));
                          }
                    )
                )
            )
          ]
      ),
    );
  }

  Widget _currentOrgText() {
    return Consumer<UserOrgModel>(
        builder: (context, userOrg, child) {
          return Text(
            //if selected org is not null, there was no image saved in provider and we called api which filled selectedOrg
              selectedOrg != null ? selectedOrg : '${userOrg.getUserOrg}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(0, 174, 229, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              )
          );
        }
    );
  }

  Widget _currentOrgImg() {
    return Consumer<UserOrgModel>(
        builder: (context, userOrg, child) {
          return Container(
            margin: EdgeInsets.only(top: 10),
            height: 100,
            width: 100,
            child: ClipOval(
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: userOrg.getOrgImg,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    IconButton(
                      icon: Icon(Icons.search),
                      iconSize: 45,
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Search())),
                    ),
              ),
            ),
          );
        }
    );
  }

  Widget _sliderContent() {
    return Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 10, bottom: 15),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 174, 229, 1),
                    borderRadius: BorderRadius.circular(100)
                ),
                child: Center(
                    child: Text(
                        threshold == 100 ? "\$1" : "${threshold.toStringAsFixed(
                            0)}\u{00A2}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        )
                    )
                )
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * .55,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Text(
                        '50\u{00A2}',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 174, 229, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _sliderAnimation,
                      builder: (context, child) =>
                          SliderTheme(
                            data: SliderThemeData(
                              thumbColor: _sliderAnimation.value,
                              overlayShape: RoundSliderOverlayShape(
                                  overlayRadius: 0),
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 10),
                              trackHeight: sliderChanging ? 10 : 4,
                              activeTrackColor: _sliderAnimation.value,
                              inactiveTrackColor: _sliderAnimation.value
                                  .withOpacity(0.3),
                              showValueIndicator: ShowValueIndicator.never,
                              activeTickMarkColor: Colors.transparent,
                              inactiveTickMarkColor: Colors.transparent,
                              disabledActiveTickMarkColor: Colors.black,
                              disabledInactiveTickMarkColor: Colors.black,
                            ),
                            child: Slider(
                              value: threshold.toDouble(),
                              onChanged: (newMax) {
                                _sliderController.value =
                                    (newMax * 2 - 100) / 100 +
                                        (newMax == 50 ? 0.01 : 0);
                                setState(() {
                                  threshold = newMax.toInt();
                                });
                              },
                              onChangeStart: (s) {
                                setState(() {
                                  sliderChanging = !sliderChanging;
                                });
                              },
                              onChangeEnd: (s) {
                                setState(() {
                                  sliderChanging = !sliderChanging;
                                  _setThreshold();
                                });
                              },
                              min: 50,
                              max: 100,
                              divisions: 10,
                            ),
                          ),

                    ),
                  ),
                  Text(
                      '\$1',
                      style: TextStyle(
                          color: Color.fromRGBO(0, 174, 229, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      )
                  )
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget _monthlyLimitContent() {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _centerContent(),
          _sometimesToggle(),
        ],
      ),
    );
  }

  Widget _centerContent() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      crossFadeState: _switchVal ? CrossFadeState.showFirst : CrossFadeState
          .showSecond,
      firstChild: _setLimit(),
      secondChild: _onOffToggle(),
    );
  }

  Widget _setLimit() {
    return Container(
      height: 120,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: SleekCircularSlider(
        min: 15,
        max: 50,
        initialValue: _initialSliderVal / 100,
        appearance: CircularSliderAppearance(
          customColors: CustomSliderColors(
            progressBarColor: Color.fromRGBO(0, 174, 229, 1),
            trackColor: Colors.lightBlue[200],
            shadowColor: Color.fromRGBO(0, 174, 229, 1),
          ),
        ),
        onChange: (double value) {
          setState(() {
            _monthLimitMoney =
                Money.fromInt((value.floor() * 100).toInt(), usdCurrency);
          });
          // callback providing a value while its being changed (with a pan gesture)
        },
        onChangeEnd: (double endValue) {
          setState(() {
            _monthLimit = (endValue.floor() * 100).toInt();
          });
          _setMonthlyLimit();
        },
        innerWidget: (double value) {
          return Align(
            alignment: Alignment.center,
            child: Text("$_monthLimitMoney"),
          );
        },
      ),
    );
  }

  Widget _sometimesToggle() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      crossFadeState: !_switchVal ? CrossFadeState.showFirst : CrossFadeState
          .showSecond,
      firstChild: Container(),
      secondChild: _onOffToggle(),
    );
  }

  Widget _onOffToggle() {
    return Container(
      margin: EdgeInsets.only(top: _switchVal ? 0 : 40),
      child: Column(
        children: <Widget>[
          Transform.scale(
            scale: _switchVal ? 1 : 1.5,
            child: Switch(
              value: _switchVal,
              onChanged: (s) {
                setState(() {
                  _switchVal = s;
                  if (!s) {
                    _monthLimit = 0;
                  } else {
                    _monthLimit = 3000;
                  }
                });
                _setMonthlyLimit();
              },
              inactiveTrackColor: Colors.grey[300],
              inactiveThumbColor: Colors.grey[500],
              activeTrackColor: Colors.lightBlue[200],
              activeColor: Colors.lightBlue[400],
            ),
          ),
          !_switchVal ? Text("Turned off") : Container(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Material(
        child: SafeArea(
          child: SlideTransition(
              position: _rightToLeft,
              child: CustomPaint(
                  painter: ChangeProfilePaint(),
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
//                margin:EdgeInsets.only(bottom:MediaQuery.of(context).size.height*.10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SlideTransition(
                              position: _topDown, child: _accountContainer()),
                          SlideTransition(
                              position: _bottomUp, child: _accountPrefs()),
                        ]
                    ),
                  )
              )
          ),
        ),
      ),
    );
  }


  //call at init state. confirms user is logged in
  _confirmLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
    print(token);
    if (token == null || token == '') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  //call at initState to get user's max threshold, last 4 digits, and bank name
  _getProfDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var content = '{"user_token":"$token"}';
    var profileResponse = await http.post(
        "${cfg.getString("host")}/users/getprofile", body: content);
    var decodedResponse = jsonDecode(profileResponse.body);
    var decodedMask = decodedResponse["mask"].toString();
    var decodedPL = decodedResponse["legalName"];
    var threshDecode = decodedResponse["threshold"];
    List cards = decodedResponse["cards"];

    print(profileResponse.body);
    setState(() {
      threshold = threshDecode;
      mask = decodedMask; //== null ? "0000" : decodedMask;
      bankName = decodedResponse["bankName"];
      profileLetter = decodedPL != null ? decodedPL[0] : "A";
      _sliderController.value =
          (threshDecode * 2 - 100) / 100 + (threshDecode == 50 ? 0.01 : 0);
      _switchVal = decodedResponse["monthlyLimit"] == null ||
          decodedResponse["monthlyLimit"] == 0 ? false : true;
      _initialSliderVal = decodedResponse["monthlyLimit"] == null ||
          decodedResponse["monthlyLimit"] == 0
          ? 3000
          : decodedResponse["monthlyLimit"];
    });

    print(threshold);
    print(mask);
    print(decodedResponse["monthlyLimit"]);
    print("cards are $cards");
    //notify provider of mask and bankName
    context.read<UserBankModel>().notify(mask, bankName, profileLetter, cards);
  }

  //if the user provider is not filled, we have to make an api call here to get info
  _getOrgInfo() async {
    if (context
        .read<UserOrgModel>()
        .getOrgImg == "" || context
        .read<UserOrgModel>()
        .getOrgImg == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');
      var orgContent = '{"user_token":"$token"}';
      var orgResponse = await http.post(
          "${cfg.getString("host")}/users/getusersorginfo", body: orgContent);
      setState(() {
        selectedOrg = jsonDecode(orgResponse.body)["name"];
        selectedOrgImg = jsonDecode(orgResponse.body)["logoLocation"];
      });
      print(selectedOrg);
      //set org name and org image in provider
      context.read<UserOrgModel>().notify(selectedOrg, selectedOrgImg);
    }
  }

  _getInitInfo() async {
    _getProfDetails();
    _getOrgInfo();
  }

  Future<bool> _onWillPop() async {
    _returnHome();
    return false;
  }

  //call on end of slider change to set user's max threshold
  _setThreshold() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var content = '{"user_token":"$token", "threshold":"${threshold.toInt()}"}';
    await http.post(
        "${cfg.getString("host")}/users/updatethreshold", body: content);
    print(threshold);
  }

  _setMonthlyLimit() async {
    var content = '{"user_token":"$token", "monthly_limit":$_monthLimit}';
    await http.post(
        "${cfg.getString("host")}/users/updatemonthlylimit", body: content);
    print(_monthLimit);
  }


  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', null);
    Navigator.pushAndRemoveUntil(
        context, PageRouteBuilder(pageBuilder: (_, __, ___) => Login()), (
        route) => false);
  }

  void _contactUs() async {
    launch('mailto:support@changecharity.io?subject=AppSupport');
  }

  void _returnHome() {
    _controller.animateBack(
        0, duration: Duration(milliseconds: 500), curve: Curves.linear);
    Future<void>.delayed(Duration(milliseconds: 500), () {
      Navigator.pushAndRemoveUntil(
          context, PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage()), (
          route) => false);
    });
  }
}
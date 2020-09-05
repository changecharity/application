import 'package:change/Models/userProfileModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:money2/money2.dart';

class MonthlyLimit extends StatefulWidget {
  MonthlyLimit(this.initialVal);

  final int initialVal;

  _MonthlyLimitState createState() => _MonthlyLimitState();
}

class _MonthlyLimitState extends State<MonthlyLimit>
    with TickerProviderStateMixin {
  GlobalConfiguration cfg = new GlobalConfiguration();
  TextEditingController _limitController = TextEditingController();

  AnimationController controller;
  Animation<Offset> _paintAnm;
  Animation<Offset> _cardsAnm;

  bool _switchVal = false;
  Money _monthLimitMoney;
  Currency usdCurrency = Currency.create('USD', 2);
  int _monthLimit;

  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _paintAnm = Tween<Offset>(
      begin: Offset(-2.0, -1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: controller, curve: Curves.fastLinearToSlowEaseIn));

    _cardsAnm = Tween<Offset>(
      begin: Offset(2.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: controller, curve: Curves.fastLinearToSlowEaseIn));

    _setInitial();

    Future<void>.delayed(Duration(milliseconds: 100), () {
      controller.forward();
    });
  }

  Widget _explainCont() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          45, MediaQuery.of(context).size.height * 0.1, 45, 60),
      child: Text(
        "Set the limit for how much to donate per month",
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      ),
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
      crossFadeState:
          _switchVal ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: _setLimit(),
      secondChild: _onOffToggle(),
    );
  }

  Widget _setLimit() {
    return Transform.scale(
      scale: 1.0,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: SleekCircularSlider(
          min: 15,
          max: 200,
          initialValue: widget.initialVal == 0 ? 30 : widget.initialVal / 100,
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
            return Center(
              child: Text(
                "$_monthLimitMoney",
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sometimesToggle() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      crossFadeState:
          !_switchVal ? CrossFadeState.showFirst : CrossFadeState.showSecond,
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
            scale: _switchVal ? 1.5 : 1.7,
            child: Switch(
              value: _switchVal,
              onChanged: (s) {
                setState(() {
                  _switchVal = s;
                  if (!s) {
                    _monthLimit = 0;
                  } else {
                    _monthLimit = 6000;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.grey[50]
              : Colors.grey[850],
      appBar: AppBar(
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.grey[50]
                : Colors.grey[850],
        elevation: 0,
        centerTitle: true,
        title: Text("Monthly Limit"),
        iconTheme: IconThemeData(
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SlideTransition(
            position: _cardsAnm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SlideTransition(
                  position: _paintAnm,
                  child: _explainCont(),
                ),
                _monthlyLimitContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _setMonthlyLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var content = '{"user_token":"$token", "monthly_limit":$_monthLimit}';
    await http.post("${cfg.getString("host")}/users/updatemonthlylimit",
        body: content);
    print(_monthLimit);
    context.read<UserProfileModel>().notify(
        context.read<UserProfileModel>().getUserPfLetter,
        context.read<UserProfileModel>().getUserName,
        context.read<UserProfileModel>().getUserThreshold,
        _monthLimit.toInt(),
        context.read<UserProfileModel>().getUserRoundUpStatus);
  }

  void _setInitial() async {
    setState(() {
      _monthLimitMoney = Money.fromInt(widget.initialVal, usdCurrency);
      widget.initialVal == 0 ? _switchVal = false : _switchVal = true;
    });
  }
}

import 'package:change/Models/userProfileModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThresholdDialog extends StatefulWidget {
  ThresholdDialog(this.initialVal);

  final int initialVal;

  _ThresholdDialogState createState() => _ThresholdDialogState();
}

class _ThresholdDialogState extends State<ThresholdDialog>
    with TickerProviderStateMixin {
  GlobalConfiguration cfg = new GlobalConfiguration();

  AnimationController controller;
  AnimationController _sliderController;
  Animation<Offset> _paintAnm;
  Animation<Offset> _cardsAnm;
  Animation<Color> _sliderAnimation;
  ColorTween _colorTween;

  bool sliderChanging = false;
  var threshold = 100;

  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _sliderController =
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

    _colorTween = ColorTween(
      begin: Colors.red[600],
      end: Color.fromRGBO(0, 174, 229, 1),
    );

    _sliderAnimation = _colorTween.animate(_sliderController);

    _setInitial();

    Future<void>.delayed(Duration(milliseconds: 100), () {
      controller.forward();
    });
  }

  Widget _explainCont() {
    return Container(
      margin: EdgeInsets.fromLTRB(45, 10, 45, 60),
      child: Text(
        "Set the maximum round-up amount per transaction",
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _sliderContent() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 10, bottom: 40),
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 174, 229, 1),
                  borderRadius: BorderRadius.circular(100)),
              child: Center(
                  child: Text(
                      threshold == 100
                          ? "\$1"
                          : "${threshold.toStringAsFixed(0)}\u{00A2}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)))),
          Container(
            width: MediaQuery.of(context).size.width * .75,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Text('50\u{00A2}',
                      style: TextStyle(
                          color: Color.fromRGBO(0, 174, 229, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _sliderAnimation,
                    builder: (context, child) => SliderTheme(
                      data: SliderThemeData(
                        thumbColor: _sliderAnimation.value,
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 10),
                        trackHeight: sliderChanging ? 10 : 4,
                        activeTrackColor: _sliderAnimation.value,
                        inactiveTrackColor:
                            _sliderAnimation.value.withOpacity(0.3),
                        showValueIndicator: ShowValueIndicator.never,
                        activeTickMarkColor: Colors.transparent,
                        inactiveTickMarkColor: Colors.transparent,
                        disabledActiveTickMarkColor: Colors.black,
                        disabledInactiveTickMarkColor: Colors.black,
                      ),
                      child: Slider(
                        value: threshold.toDouble(),
                        onChanged: (newMax) {
                          _sliderController.value = (newMax * 2 - 100) / 100 +
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
                Text('\$1',
                    style: TextStyle(
                        color: Color.fromRGBO(0, 174, 229, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
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
        title: Text("Transaction Max"),
        iconTheme: IconThemeData(
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
      ),
      body: SafeArea(
        child: SlideTransition(
          position: _cardsAnm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _paintAnm,
                child: _explainCont(),
              ),
              _sliderContent(),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
              ),
            ],
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

  void _setInitial() {
    setState(() {
      _sliderController.value = (widget.initialVal * 2 - 100) / 100 +
          (widget.initialVal == 50 ? 0.01 : 0);
      threshold = context.read<UserProfileModel>().getUserThreshold;
    });
  }

  void _setThreshold() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var content = '{"user_token":"$token", "threshold":"${threshold.toInt()}"}';
    await http.post("${cfg.getString("host")}/users/updatethreshold",
        body: content);
    print(threshold);
    context.read<UserProfileModel>().notify(
        context.read<UserProfileModel>().getUserPfLetter,
        context.read<UserProfileModel>().getUserName,
        threshold.toInt(),
        context.read<UserProfileModel>().getUserMonthlyLimit,
        context.read<UserProfileModel>().getUserRoundUpStatus);
  }
}

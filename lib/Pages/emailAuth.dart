import 'package:change/Pages/linkCredit.dart';
import 'package:change_charity_components/change_charity_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Pages/forgotPass.dart';
import '../Pages/login.dart';
import '../Pages/orgSelected.dart';
import 'linkCredit.dart';

class EmailAuth extends StatefulWidget {
  final emailAddress;
  final action;

  EmailAuth(this.emailAddress, this.action);

  @override
  _EmailAuthState createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _loadingController;
  Animation<Offset> _paintAn;
  Animation<Offset> _bodyAn;
  Animation<Color> _loadingAn;
  final _pinController = TextEditingController();
  final focusNode = FocusNode();
  String token;
  String _pinError = '';
  String resendText = "Resend Code";
  bool canResend = true;
  bool missingChar = false;
  bool loading = false;
  bool resendLoading = false;
  GlobalConfiguration cfg = new GlobalConfiguration();

  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _loadingController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _paintAn = Tween<Offset>(begin: Offset(-1.0, -1.0), end: Offset(0, 0))
        .animate(CurvedAnimation(
            curve: Curves.fastLinearToSlowEaseIn, parent: _controller));

    _bodyAn = Tween<Offset>(begin: Offset(1, 2), end: Offset(0, 0)).animate(
        CurvedAnimation(
            curve: Curves.fastLinearToSlowEaseIn, parent: _controller));
    _loadingAn = _loadingController.drive(
        ColorTween(begin: Colors.lightBlue[200], end: Colors.lightBlue[600]));

    Future<void>.delayed(Duration(milliseconds: 500), () {
      _controller.forward();
    });

    _loadingController.repeat();

    _getToken();
    _timePassed();
  }

  Widget _emailIcon() {
    return Container(
        child: Icon(
      Icons.email,
      size: 100,
      color: Color.fromRGBO(0, 174, 229, 1),
    ));
  }

  Widget _backButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10),
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        iconSize: 30,
        onPressed: () {
          _clearSharedPrefs();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        },
      ),
    );
  }

  Widget _verifyText() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Verify Email',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                  'Please enter the 6 digit code sent to ${widget.emailAddress}',
                  style: TextStyle(fontSize: 14)))
        ]));
  }

  Widget _pinCode() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width * .75,
        child: PinCodeTextField(
          onSubmitted: (s) {
            if (_pinController.text.length < 6) {
              setState(() {
                missingChar = !missingChar;
                print('missing chars');
                print(missingChar);
              });
            }
          },
          onChanged: (s) {
            setState(() {
              _pinError = '';
            });
          },
          length: 6,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            //borderWidth:4,
            // borderRadius: BorderRadius.circular(5),
            inactiveColor: !missingChar ? Colors.grey : Colors.red,
            activeColor: Color.fromRGBO(0, 174, 229, 1),
            selectedColor: !missingChar ? Colors.grey : Colors.red,
            fieldHeight: 50,
            fieldWidth: 40,
          ),
          animationType: AnimationType.scale,
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          textStyle:
              TextStyle(color: Color.fromRGBO(0, 174, 229, 1), fontSize: 30),
          textInputType: TextInputType.number,
          controller: _pinController,
          focusNode: focusNode,
        ));
  }

  Widget _resendCont() {
    return Container(margin: EdgeInsets.only(top: 10), child: _resendContent());
  }

  Widget _resendContent() {
    if (canResend) {
      return GestureDetector(
          onTap: () {
            _resend();
          },
          child: _resendTxt());
    }
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_resendTxt(), _resendLoadInd()]));
  }

  Widget _resendTxt() {
    return Text(resendText,
        style: TextStyle(color: Color.fromRGBO(0, 174, 229, 1), fontSize: 12));
  }

  Widget _resendLoadInd() {
    if (resendLoading) {
      return Container(
          margin: EdgeInsets.only(left: 18),
          child: SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                  strokeWidth: 2, valueColor: _loadingAn)));
    }
    return Container();
  }

  Widget _errorCont() {
    return Container(
      child: Text(_pinError, style: TextStyle(color: Colors.red)),
    );
  }

  Widget _verify() {
    return ChangeSubmitRow(
      loading: loading,
      animation: _loadingAn,
      onClick: _verifyAccount,
      text: MediaQuery.of(context).size.height > 700 ? "Verify" : '',
    );
  }

  Widget _mainBodyContainer() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _backButton(),
        Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).viewInsets.bottom == 0
                    ? MediaQuery.of(context).size.height > 700
                        ? MediaQuery.of(context).size.height * .15
                        : MediaQuery.of(context).size.height * 0.1
                    : MediaQuery.of(context).size.height * .03),
            width: MediaQuery.of(context).size.width * .85,
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * .07,
                40,
                MediaQuery.of(context).size.width * .07,
                50),
            decoration: BoxDecoration(
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? Colors.grey[100]
                    : Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset.fromDirection(.9),
                    blurRadius: 10,
                  )
                ]),
            child: Column(children: [
              _emailIcon(),
              _verifyText(),
              _pinCode(),
              _errorCont(),
              widget.action == "signup" ? _resendCont() : Container(),
            ])),
        Container(
          height: 20,
        ),
        _verify(),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: SafeArea(
          child: SlideTransition(
              position: _paintAn,
              child: CustomPaint(
                  painter: ChangeBankPaint(),
                  child: SlideTransition(
                      position: _bodyAn,
                      child: SingleChildScrollView(
                          child: _mainBodyContainer()))))),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  _timePassed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var time = prefs.getString('time');
    if (DateTime.now().isAfter(DateTime.parse(time))) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
      print('time elapsed');
      return;
    } else {
      Future<void>.delayed(Duration(minutes: 1), () {
        _timePassed();
      });
    }
  }

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      print(token);
      if (token == null || token == "") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }

  _clearSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', null);
    prefs.setString('signUpEmail', null);
    prefs.setString('forgotPassEmail', null);
  }

  _resend() async {
    setState(() {
      canResend = !canResend;
      resendText = "Sending";
      resendLoading = !resendLoading;
    });

    var content = '{"user_token":"$token"}';
    var response = await http
        .post("${cfg.getString("host")}/users/resendemailkey", body: content);

    print(response.body);
    if (response.body == "unknown token") {
      setState(() {
        resendLoading = !resendLoading;
        //Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>SignUp()));
        _pinError = "Invalid user. Please sign up";
      });
    } else if (response.body == "success:true") {
      setState(() {
        resendLoading = !resendLoading;
        resendText = "Sent";
      });
      Future<void>.delayed(Duration(seconds: 3), () {
        setState(() {
          canResend = !canResend;
          resendText = "Resend Code";
        });
      });
    }
  }

  bool _checkValidPin() {
    bool containsLetter = RegExp(r"[A-Za-z]").hasMatch(_pinController.text);

    if (_pinController.text.length < 6) {
      setState(() {
        _pinError = "Code must be 6 digits long.";
        missingChar = !missingChar;
      });
      return false;
    } else if (containsLetter) {
      setState(() {
        _pinError = "Code must be only numbers";
      });
      return false;
    }
    return true;
  }

  _verifyAndSignup() async {
    var content =
        '{"user_token":"$token","key":${int.parse(_pinController.text)}}';
    var response = await http
        .post("${cfg.getString("host")}/users/updatesignup", body: content);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(response.body);

    if (response.body == "key is incorrect") {
      setState(() {
        loading = !loading;
        _pinError = "Incorrect code. Please try again.";
        return;
      });
    } else if (response.body.contains("invalid user token")) {
      prefs.setString('signUpEmail', null);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } else if (response.body == "success") {
      prefs.setString('signUpEmail', null);
      prefs.setString('linkBank', "");
      if (prefs.getInt('selOrg') != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => OrgSelected()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LinkCredit()));
      }
    } else {
      setState(() {
        loading = !loading;
        _pinError = "Unknown Error, try again";
        return;
      });
    }
  }

  _verifyAndEnterPass() async {
    var content =
        '{"user_token": "$token", "key":${int.parse(_pinController.text)}}';
    var response = await http.post("${cfg.getString("host")}/users/validkey",
        body: content);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(response.body);

    if (response.body.contains("wrong key")) {
      setState(() {
        loading = !loading;
        _pinError = "Incorrect code. Please try again.";
        return;
      });
    } else if (response.body.contains("invalid user token")) {
      prefs.setString('forgotPassEmail', null);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } else if (response.body.contains("success")) {
      prefs.setString('forgotPassEmail', null);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ForgotPass(int.parse(_pinController.text))));
    }
  }

  _verifyAccount() async {
    if (!_checkValidPin()) {
      setState(() {
        return;
      });
    } else {
      setState(() {
        loading = !loading;
      });
      if (widget.action == "signup") {
        print("verifyandsignup");
        _verifyAndSignup();
      } else if (widget.action == "forgotpass") {
        print("verifyandenterpass");
        _verifyAndEnterPass();
      }
    }
  }
}

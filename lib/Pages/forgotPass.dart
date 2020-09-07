import 'package:change_charity_components/change_charity_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'signup.dart';

class ForgotPass extends StatefulWidget {
  final int pin;

  ForgotPass(this.pin);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> with TickerProviderStateMixin {
  String _passErr = "";
  String token;
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  bool obscurePass = true;
  bool obscurePass2 = true;
  bool loading = false;
  final passFocusNode = FocusNode();
  final confirmFocusNode = FocusNode();
  GlobalConfiguration cfg = new GlobalConfiguration();

  AnimationController _loadingController;
  Animation<Color> _loadingAn;

  void initState() {
    super.initState();

    _getToken();
    _loadingController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _loadingAn = _loadingController.drive(
        ColorTween(begin: Colors.lightBlue[200], end: Colors.lightBlue[600]));
    _loadingController.repeat();
  }

  Widget _passIcon() {
    return Container(
        alignment: Alignment.center,
        child: Icon(
          Icons.lock,
          size: 100,
          color: Color.fromRGBO(0, 174, 229, 1),
        ));
  }

  Widget _forgotPassText() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Reset Password',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Text('Please enter your new password',
                  style: TextStyle(fontSize: 16)))
        ]));
  }

  Widget _passInput() {
    return ChangeTextInput(
      controller: _passController,
      autofillHint: AutofillHints.newPassword,
      errMsg: _passErr,
      focusNode: passFocusNode,
      isPassword: true,
      prefixIcon: Icons.lock,
      hintText: 'Password',
      errFunc: (s) {
        setState(() {
          _passErr = s;
        });
      },
    );
  }

  Widget _confirmPassInput() {
    return ChangeTextInput(
      controller: _confirmController,
      autofillHint: AutofillHints.newPassword,
      focusNode: confirmFocusNode,
      isPassword: true,
      prefixIcon: Icons.lock,
      hintText: 'Confirm Password',
      last: true,
      lastFunc: _resetPass,
    );
  }

  Widget _reset() {
    return ChangeSubmitRow(
      onClick: _resetPass,
      animation: _loadingAn,
      loading: loading,
      text: MediaQuery.of(context).size.height > 700 ? "Reset" : "",
    );
  }

  Widget _mainBodyContainer() {
    return Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).viewInsets.bottom == 0
                      ? MediaQuery.of(context).size.height > 700
                          ? MediaQuery.of(context).size.height * .2
                          : MediaQuery.of(context).size.height * 0.15
                      : MediaQuery.of(context).size.height * .01),
              width: MediaQuery.of(context).size.width * .85,
              padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
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
                        blurRadius: 10)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _passIcon(),
                  _forgotPassText(),
                  Container(
                    height: 30,
                  ),
                  _passInput(),
                  _confirmPassInput(),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _reset(),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: CustomPaint(
            painter: ChangeBankPaint(),
            child: SingleChildScrollView(child: _mainBodyContainer()),
          ),
        ),
      ),
    );
  }

  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      print(token);
      if (token == null || token == "") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUp()));
      }
    });
  }

  bool _validPass() {
    bool containsCap = RegExp(r"[A-Z]").hasMatch(_passController.text);
    var containsNumb = RegExp(r"\d").hasMatch(_passController.text);
    //regex not working for this.have to fix:
//    var containsSpecialChar=RegExp(r"^\W").hasMatch(_passController.text);
    if (_passController.text == '' || _passController.text == null) {
      setState(() {
        _passErr = "This field can't be blank";
      });
      return false;
    } else if (_passController.text.length < 6) {
      setState(() {
        _passErr = "Must be longer than 6 characters";
      });
      return false;
    } else if (!containsCap) {
      setState(() {
        _passErr = "Must contain at least one capital letter";
      });
      return false;
    } else if (!containsNumb) {
      setState(() {
        _passErr = "Must contain at least one number";
      });
      return false;
    } else if (_confirmController.text == '' ||
        _confirmController.text == null) {
      setState(() {
        _passErr = "Please confirm password";
      });
    }
    return true;
  }

  bool _matchingPass() {
    if (_confirmController.text != _passController.text) {
      setState(() {
        _passErr = "Passwords do not match";
      });
      return false;
    }
    return true;
  }

  void _resetPass() async {
    if (!_validPass() || !_matchingPass()) {
      setState(() {
        return;
      });
    } else {
      setState(() {
        loading = !loading;
      });

      var content =
          '{"user_token":"$token", "password":"${_passController.text}", "key":${widget.pin}}';
      var response = await http
          .post("${cfg.getString("host")}/users/forgotpass", body: content);
      print(response.body);
      if (response.body.contains("success")) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    }
  }
}

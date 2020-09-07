import 'package:change_charity_components/change_charity_components.dart';
import 'package:change_charity_components/paintings.dart';
import 'package:change_charity_components/submit_row.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'emailAuth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  Animation<Offset> animation;
  Animation<Offset> animationB;
  Animation<Color> loadingAn;
  AnimationController controller;
  AnimationController loadingController;
  double drawTime = 0.0;
  double drawDuration = 1.8;

  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  final _emailController = TextEditingController();

  // final _confirmPassController = TextEditingController();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passFocusNode = FocusNode();
  final confirmPassFocusNode = FocusNode();
  final tosFocusNode = FocusNode();
  String _nameErr = '';
  String _passErr = '';

  // String _confirmPassErr = '';
  String _emailErr = '';
  bool obscurePass = true;
  bool loading = false;
  bool _tosAccepted = false;

  GlobalConfiguration cfg = new GlobalConfiguration();

  void initState() {
    super.initState();

    //set animations
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: drawDuration.toInt()));
    loadingController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    animation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    ));
    animationB = Tween<Offset>(
      begin: Offset(2.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    ));
    loadingAn = loadingController.drive(
        ColorTween(begin: Colors.lightBlue[200], end: Colors.lightBlue[600]));

    loadingController.repeat();

    Future<void>.delayed(Duration(milliseconds: 500), () {
      controller.forward();
      print(animation.value);
    });
  }

  //back icon, takes back to login page
  Widget _backButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10),
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        iconSize: 30,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  //Sign Up
  Widget _signUpText() {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      return Text("");
    }
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).viewInsets.bottom == 0
              ? MediaQuery.of(context).size.height < 700
                  ? 0
                  : MediaQuery.of(context).size.height * 0.05
              : 0),
      alignment: Alignment.center,
      child: Text(
        'Sign Up',
        style: TextStyle(
          fontSize: 55,
        ),
      ),
    );
  }

  Widget _nameInput() {
    return ChangeTextInput(
      controller: _nameController,
      focusNode: nameFocusNode,
      autofillHint: AutofillHints.name,
      hintText: 'Legal Name',
      prefixIcon: Icons.person_outline_rounded,
      errMsg: _nameErr,
      errFunc: (s) {
        setState(() {
          _nameErr = s;
        });
      },
    );
  }

  Widget _emailInput() {
    return ChangeTextInput(
      controller: _emailController,
      autofillHint: AutofillHints.email,
      focusNode: emailFocusNode,
      hintText: 'Email',
      prefixIcon: Icons.mail_outline_rounded,
      errMsg: _emailErr,
      errFunc: (s) {
        setState(() {
          _emailErr = s;
        });
      },
    );
  }

  Widget _passInput() {
    return ChangeTextInput(
      controller: _passController,
      focusNode: passFocusNode,
      autofillHint: AutofillHints.newPassword,
      isPassword: true,
      hintText: 'Password',
      prefixIcon: Icons.lock_outline_rounded,
      errMsg: _passErr,
      errFunc: (s) {
        setState(() {
          _passErr = s;
        });
      },
    );
  }

  // Widget _confirmPassInput() {
  //   return ChangeTextInput(
  //     controller: _confirmPassController,
  //     autofillHint: AutofillHints.newPassword,
  //     focusNode: confirmPassFocusNode,
  //     isPassword: true,
  //     last: true,
  //     hintText: 'Confirm Password',
  //     prefixIcon: Icons.lock_outline_rounded,
  //     errMsg: _confirmPassErr,
  //     errFunc: (s) {
  //       setState(() {
  //         _confirmPassErr = s;
  //       });
  //     },
  //   );
  // }

  Widget _tosPrivacyCont() {
    return Container(
      margin: EdgeInsets.only(left: 30),
      child: Row(
        children: [
          Checkbox(
            value: _tosAccepted,
            checkColor: Colors.lightBlue[900],
            activeColor: Colors.orange[200],
            focusColor: Colors.red[500],
            autofocus: true,
            focusNode: tosFocusNode,
            onChanged: (bool newVal) {
              setState(() {
                _tosAccepted = !_tosAccepted;
              });
            },
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              children: [
                TextSpan(
                  text: 'I agree to the ',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(
                        () {
                          _tosAccepted = !_tosAccepted;
                        },
                      );
                    },
                ),
                TextSpan(
                  text: 'Terms',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        _launchURL("https://changecharity.io/terms-of-service"),
                ),
                TextSpan(
                  text: ' and ',
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        _launchURL("https://changecharity.io/privacy-policy"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Sign up button. Switches to loading on load
  Widget _signUpCont() {
    return ChangeSubmitRow(
      animation: loadingAn,
      loading: loading,
      onClick: _signUp,
      text: MediaQuery.of(context).size.height > 700 ? "Sign Up" : '',
    );
  }

  //page layout
  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SlideTransition(
            position: animation,
            child: CustomPaint(
              painter: ChangeSignUpPaint(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SlideTransition(
                  position: animationB,
                  child: SingleChildScrollView(
                    child: AutofillGroup(
                      child: Column(
                        children: <Widget>[
                          _backButton(),
                          _signUpText(),
                          Container(
                            height: MediaQuery.of(context).viewInsets.bottom ==
                                    0
                                ? MediaQuery.of(context).size.height > 700
                                    ? 100
                                    : MediaQuery.of(context).size.height * 0.08
                                : 0,
                          ),
                          _nameInput(),
                          _emailInput(),
                          _passInput(),
                          _tosPrivacyCont(),
                          _signUpCont(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    loadingController.dispose();
    super.dispose();
  }

  //uses SharedPreferences to set token on sign up.
  //If token available(sign up successful), pushes to verify page
  void _saveSignUp(val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', val);
    prefs.setString('signUpEmail', "${_emailController.text}");
    if (prefs.getString('token') != null && prefs.getString('token') != '') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => EmailAuth(_emailController.text, "signup")),
          (route) => false);
    }
  }

  //sets the time plus thirty minutes to store in shared preferences.
  //On verify page, after 30 minutes, get redirected back to sign up. account is no longer valid.
  void _setTime() async {
    var timePlusThirty = DateTime.now().add(new Duration(seconds: 1800));
    SharedPreferences timePref = await SharedPreferences.getInstance();
    timePref.setString('time', timePlusThirty.toString());
    print(timePlusThirty.toString());
  }

  bool _checkValidName() {
    if (_nameController.text == '' || _nameController.text == null) {
      setState(() {
        _nameErr = "This field can't be blank";
      });
      return false;
    }
    return true;
  }

  //throws errors if email isn't valid
  bool _checkValidEmail() {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text);

    if (_emailController.text == '' || _emailController.text == null) {
      setState(() {
        _emailErr = "This field can't be blank";
      });
      return false;
    } else if (!emailValid) {
      setState(() {
        _emailErr = "This is not a valid email address";
      });
      return false;
    }
    return true;
  }

  //throws errors if password isn't valid
  bool _checkValidPassword() {
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
    }
    // else if (_passController.text != _confirmPassController.text) {
    //   setState(() {
    //     _confirmPassErr = "Passwords do not match";
    //   });
    //   return false;
    // }
    return true;
  }

  //called on click of sign up button. checks email, password, and plaid before making api call and signing up.
  //if sign up is successful, api sends back token which gets stored in shared preferences
  _signUp() async {
    if (!_checkValidName() || !_checkValidEmail() || !_checkValidPassword()) {
      return;
    } else {
      setState(() {
        loading = !loading;
      });
      var content =
          '{"legal_name":"${_nameController.text}","email":"${_emailController.text}","password":"${_passController.text}"}';
      var response = await http
          .post("${cfg.getString("host")}/users/signup", body: content)
          .timeout(Duration(seconds: 7));

      print(response.body);

      if (response.body == "email exists") {
        setState(() {
          _emailErr = "Email Taken";
          loading = !loading;
        });
        return;
      } else if (response.body
          .startsWith("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9")) {
        _saveSignUp(response.body);
        _setTime();
        print("successful");
      }
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

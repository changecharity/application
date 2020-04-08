import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'signup.dart';


class Login extends StatefulWidget{
  @override
  _LoginState createState () => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin{
  Animation<Offset> animation;
  Animation<Offset> animationB;
  AnimationController controller;

  double drawTime = 0.0;
  double drawDuration = 2.0;

  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(seconds: drawDuration.toInt()));

    animation = Tween<Offset>(
      begin: Offset(-1.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
    animationB = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
//      todo: replace with controller b
      parent: controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
    Future<void>.delayed(Duration(milliseconds: 1000), () {
      controller.forward();
    });
  }

  Widget _helloContainer() {
    return Container(
      margin: EdgeInsets.only(top: 140),
      alignment: Alignment.center,
      child: Text(
        'Hello',
        style: TextStyle(
          fontSize: 95,
        ),
      ),
    );
  }

  Widget _messageContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: Text(
        'Sign in to your account',
        style: TextStyle(
          fontSize: 25,
        ),
      ),
    );
  }

  Widget _emailInput() {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, top: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [BoxShadow(
          color: Colors.grey[350],
          blurRadius: 20.0,
          offset: Offset.fromDirection(0.9),
        ),],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Email",
          prefixIcon:  _emailPrefix(),
        ),
      ),
    );
  }

  Widget _emailPrefix() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 15),
      child: Icon(
        Icons.email,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _passInput() {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, top: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [BoxShadow(
          color: Colors.grey[350],
          blurRadius: 20.0,
          offset: Offset.fromDirection(0.9),
        ),],
      ),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Password",
          prefixIcon:  _passPrefix(),
          suffixIcon:  _passSuffix(),
        ),
      ),
    );
  }

  Widget _passPrefix() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 15),
      child: Icon(
        Icons.lock,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _passSuffix() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 25),
      child: Icon(
        Icons.remove_red_eye,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _forgotPass() {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(right: 35, top: 25),
      child: Text(
        'Forgot your password?',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _signinButton() {
    return Container(
      margin: EdgeInsets.only(right: 20, top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Sign In',
              style: TextStyle(
                fontSize: 35,
              ),
            ),
          ),
          Container(
            child: RaisedButton(
              onPressed: (){
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context)=> SignUp())
                );
              },
              padding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(60))),
              child: Ink(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.lightBlue[400], Colors.lightBlue[300]],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30.0)
                ),
                child: Icon(Icons.arrow_forward, color: Colors.white,size: 30,),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createText() {
    return Container(
      margin: EdgeInsets.only(top: 70),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text(
              "Don't have an account?",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> SignUp())
              );
            },
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SlideTransition(
          position: animationB,
          child: CustomPaint(
            painter: BobRoss(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SlideTransition(
                position: animation,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _helloContainer(),
                     _messageContainer(),
                      _emailInput(),
                      _passInput(),
                      _forgotPass(),
                      _signinButton(),
                      _createText(),
                    ],
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
    super.dispose();
  }
}

class BobRoss extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paintA = Paint()
    ..color = Colors.lightBlue[200]
    ..style = PaintingStyle.fill;
    var paintB = Paint()
      ..color = Colors.lightBlue[400].withOpacity(0.8)
      ..style = PaintingStyle.fill;

    var pathA = Path();
    pathA.moveTo(size.width, -70);
    pathA.lineTo(size.width*0.75, -75);
    pathA.quadraticBezierTo(
        size.width * 0.37, size.height * 0.1,
        size.width*0.63, size.height* 0.13);
    pathA.quadraticBezierTo(
        size.width * 0.83, size.height * 0.15,
        size.width*0.8, size.height* 0.25);
    pathA.quadraticBezierTo(
        size.width * 0.8, size.height * 0.35,
        size.width, size.height* 0.26);
    canvas.drawPath(pathA, paintA);

    var pathB = Path();
    pathB.moveTo(size.width, -70);
    pathB.lineTo(size.width*0.6, -70);
    pathB.quadraticBezierTo(
        size.width * 0.53, size.height * 0.1,
        size.width*0.7, size.height* 0.1);
    pathB.quadraticBezierTo(
        size.width * 0.9, size.height * 0.11,
        size.width*0.82, size.height* 0.2);
    pathB.quadraticBezierTo(
        size.width * 0.67, size.height * 0.33,
        size.width, size.height* 0.25);
    canvas.drawPath(pathB, paintB);
  }

  @override
  bool shouldRepaint(BobRoss oldDelegate) => false;
}
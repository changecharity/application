import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecurityFAQ extends StatefulWidget {
  _SecurityFAQState createState() => _SecurityFAQState();
}

class _SecurityFAQState extends State<SecurityFAQ> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<Offset> _paintAnm;
  Animation<Offset> _cardsAnm;

  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(seconds:  1));
    _paintAnm = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.fastLinearToSlowEaseIn
    )
    );

    _cardsAnm = Tween<Offset>(
      begin: Offset(2.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.fastLinearToSlowEaseIn
    )
    );

    Future<void>.delayed(Duration(milliseconds: 500), () {
      controller.forward();
    });
  }

  Widget _questionContainer(String title, body) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        children: [
          _titleText(title),
          _bodyText(body),
        ],
      ),
    );
  }

  Widget _titleText(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }

  Widget _bodyText(String text) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey[50] : Colors.grey[850],
      appBar: AppBar(
        backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey[50] : Colors.grey[850],
        elevation: 0,
        centerTitle: true,
        title: Text("Security Overview"),
        iconTheme: IconThemeData(
          color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white,
        ),
      ),
      body: SafeArea(
        child: SlideTransition(
          position: _paintAnm,
          child: SlideTransition(
            position: _cardsAnm,
            child: ListView(
              children: [
                _questionContainer(
                  "Why do I need to link my bank account?",
                  "Change Charity uses ACH transfers to ensure your charity gets the most out of your donations. "
                  "Linking your bank account enables us to round up your credit transactions, while a credit card does not provide us with that ability.",
                ),
                _questionContainer(
                  "How can I be sure no one can see my credentials?",
                  "Change Charity uses a financial technology service called Plaid, to ensure you have the highest level of protection. "
                  "We store none of your sensitive information, and can guarantee complete security.",
                ),
                _questionContainer(
                  "Can I link my credit account after I link my checking account?",
                  "After you link your checking account, you have the ability to link multiple credit accounts. "
                  "All your transactions are read-only, and none of your transaction hisotry is shared with your charity.",
                ),
                _questionContainer(
                  "Are my donation tax deductible?",
                  "Every donation you make to a charity through Change Charity, is fully tax deductible. At the end of every month, we will email you a receipt of all your months donations.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
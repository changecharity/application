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
        title: Text("FAQ"),
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
                    "How do I know my credit card info will be secured?",
                    "Change Charity works with Stripe to securely handle your credit card and payments. We ensure that none of your sensitive information is stored."
                ),
                _questionContainer(
                    "How do I know my bank info will be secured?",
                    "Change Charity works with Plaid to securely link your bank account. We will never charge your bank account, and it is only used for reading your new transaction amounts."
                    " Plaid is used by companies such as Venmo and Robinhood, and it uses industry standard security methods."

                ),
                _questionContainer(
                  "Why do I need to link my credit card and Credit Card Account?",
                  "Change Charity requires you to link a payment method, along with a round-up account. Your payment method is write-only, and strictly used for creating charges."
                      " Your round-up account(s) enables us to monitor and securely round up your transactions. Your round-up account is read-only, and cannot be used to make charges."
                      " All charges are made to your credit card for extra security and assurance.",
                ),
                _questionContainer(
                  "Can't I just link my credit card without the need for my Credit Card Account?",
                  "For security, Change Charity only creates charges to your credit card. Your credit card does not provide any round-up ability, and "
                      "therefore we require a Credit Card Account. "
                  "We store none of your sensitive information, and can guarantee complete security.",
                ),
                _questionContainer(
                  "Can I link multiple Credit Card Accounts and have them all be round-ups?",
                  "After you link your payment method, you can add as many Credit Card Accounts as you like."
                ),
                _questionContainer(
                  "Are my donations tax deductible?",
                  "Every donation you make to a charity through Change Charity is fully tax deductible. At the end of every month, we will email you a receipt of all your months donations.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
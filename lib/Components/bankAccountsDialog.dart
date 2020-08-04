import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:change_charity_components/change_charity_components.dart';
import '../Models/userBankModel.dart';
import 'passwordDialog.dart';
import 'changeAccountDialog.dart';

class BankAccountsDialog extends StatefulWidget {
  _BankAccountDialogState createState() => _BankAccountDialogState();
}

class _BankAccountDialogState extends State<BankAccountsDialog> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<Offset> _paintAnm;
  Animation<Offset> _cardsAnm;

  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(seconds:  1));
    _paintAnm = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
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

    Widget _bankCard(icon, type, mask, bankName, first) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1,vertical: MediaQuery.of(context).size.height * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey[100] : Colors.grey[900],
        boxShadow: [BoxShadow(
            color: MediaQuery
                .of(context)
                .platformBrightness == Brightness.light ? Colors
                .grey[300] : Colors.grey[700],
            offset: Offset.fromDirection(1),
            blurRadius: 15),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30, left: 30),
                child: Icon(
                  icon,
                  size: 45,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 30, left: 30),
                  child: Center(
                    child: Text(
                      type,
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 30, left: 30),
            child: Text(
              'XXXX-XXXX-XXXX-$mask',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 30, bottom: 30),
            child: Text(
              bankName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          first ? Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 30, bottom: 20),
                child: GestureDetector(
                  onTap: (){
                    showDialog(context: context,
                        builder: (context) =>
                            PasswordDialog("change"),
                        barrierDismissible: true);
                    },
                  child: Text(
                    'Change Account',
                    style: TextStyle(
                      decoration: TextDecoration.underline
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 30, bottom: 20),
                child: GestureDetector(
                  onTap: (){
                    showDialog(context: context,
                        builder: (context) =>
                            PasswordDialog("unlink"),
                        barrierDismissible: true);
                  },
                  child: Text(
                    'Delete Account',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ) : Container(),
        ],
      ),
    );
  }

  Widget _accounts() {
    return Consumer<UserBankModel>(
      builder: (context, userBank, child) {
        return ListView.builder(
          itemCount: userBank.getCards.length + 2,
          itemBuilder: (context, idx) {
            if (idx < userBank.getCards.length + 1) {
              print(userBank.getCards);
              return _bankCard(
                idx == 0 ? Icons.business : Icons.credit_card,
                idx == 0 ? 'Checking' : 'Credit Card',
                idx == 0 ? userBank.getMask : userBank.getCards[idx-1]["mask"],
                idx == 0 ? userBank.getBankName : userBank.getCards[idx-1]["bankName"],
                idx == 0 ? true : false,
              );
            }
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.20, vertical: 30),
              child: MaterialButton(
                onPressed: (){
                  showDialog(context:context, builder:(context)=>ChangeAccDialog(password: "", action: "new",), barrierDismissible: true);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  side: BorderSide(
                    style: BorderStyle.solid,
                    color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white,
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    Text('Add Credit Card'),
                  ],
                ),
              ),
            );
          }
        );
      }
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
          title: Text("Bank Accounts"),
          iconTheme: IconThemeData(
             color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white,
          ),
        ),
        body: SafeArea(
          child: SlideTransition(
            position: _paintAnm,
            child: CustomPaint(
              painter: ChangeSignUpPaint(),
              child: SlideTransition( position: _cardsAnm, child: _accounts()),
            ),
          ),
        ),
    );
  }
}
import 'package:flutter/services.dart';
import 'package:change/Components/monthlyLimitDialog.dart';
import 'package:change/Components/settingsDialog.dart';
import 'package:change/Components/thresholdDialog.dart';
import 'package:change/Models/userProfileModel.dart';
import 'package:change_charity_components/change_charity_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money2/money2.dart';

import '../Models/userOrgModel.dart';
import '../Models/userBankModel.dart';

import '../Components/bankAccountsDialog.dart';

import 'linkBank.dart';
import 'linkCredit.dart';
import 'homePage.dart';
import 'Search.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _paintAn;
  Animation<Offset> _topAn;
  Animation<Offset> _contentAn;

  Currency usdCurrency = Currency.create('USD', 2);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this, duration: Duration(milliseconds: 1200),);

    _paintAn = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.fastLinearToSlowEaseIn
      ),
    );

    _topAn = Tween<Offset>(
      begin: Offset(1.0, -2.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.fastLinearToSlowEaseIn
      ),
    );

    _contentAn = Tween<Offset>(
      begin: Offset(-2.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.fastLinearToSlowEaseIn
      ),
    );

    Future<void>.delayed(Duration(milliseconds: 300), () {
      _controller.forward();
    });
  }

  Widget _backButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 16),
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        iconSize: 30,
        onPressed: () async {
          _returnHome();
        },
      ),
    );
  }

  Widget _settingsButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 16),
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: Icon(Icons.settings),
        iconSize: 30,
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return SettingsDialog();
              },
              fullscreenDialog: true
          ));
        },
      ),
    );
  }

  Widget _nameAndDate() {
    return Consumer<UserProfileModel>(
        builder: (context, userPF, child) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            leading: Container(
              child: Center(
                child: Text(
                  userPF.getUserPfLetter,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.lightBlue[400],
                shape: BoxShape.circle,
              ),
            ),
            title: Text(userPF.getUserName),
//          subtitle: Text('Donor since August 2008'),
          );
        }
    );
  }

  Widget _org() {
    return Consumer<UserOrgModel>(
        builder: (context, userOrg, child) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
            leading: Icon(Icons.local_library),
            title: Text("Current Organization"),
            subtitle: Text(userOrg.getUserOrg),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Search()));
            },
          );
        }
    );
  }

  Widget _paymentMethod() {
    return Consumer<UserBankModel>(
        builder: (context, userBank, child) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
            leading: Icon(Icons.credit_card),
            title: Text('Payment Method'),
            subtitle: userBank.getBankName == null ? Text(
              "Link your Payment Method",
              style: TextStyle(color: Colors.redAccent),) : Text(
                "${userBank.getBankName} ...${userBank.getMask}"),
            onTap: () {
              userBank.getBankName == null ?
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => LinkCredit())) : Navigator
                  .of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return BankAccountsDialog();
                  },
                  fullscreenDialog: true
              ));
            },
          );
        }
    );
  }

  Widget _roundUpAccounts() {
    return Consumer<UserBankModel>(
        builder: (context, userBank, child) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
            leading: Icon(Icons.account_balance),
            title: Text('Round Up Accounts'),
            subtitle: _roundUpText(),
            onTap: _roundUpAction,
          );
        }
    );
  }

  Widget _roundUpText() {
    var bankName = context
        .read<UserBankModel>()
        .getBankName;
    var length = context
        .read<UserBankModel>()
        .getCards
        .length;

    if (bankName == null) {
      return Text(
        "Link your Payment Method", style: TextStyle(color: Colors.redAccent),);
    } else if (length == 0) {
      return Text("Link your Round Up Account",
        style: TextStyle(color: Colors.redAccent),);
    } else {
      return Text("$length account${length == 1 ? '' : 's'} connected");
    }
  }

  void _roundUpAction() {
    var bankName = context
        .read<UserBankModel>()
        .getBankName;
    var length = context
        .read<UserBankModel>()
        .getCards
        .length;

    if (bankName == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => LinkCredit()));
    } else if (length == 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => LinkBank()));
    } else {
      Navigator.of(context).push(
          new MaterialPageRoute<Null>(builder: (BuildContext context) {
            return BankAccountsDialog();
          }, fullscreenDialog: true));
    }
  }

  Widget _transactionMax() {
    return Consumer<UserProfileModel>(
        builder: (context, userPF, child) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
            leading: Icon(Icons.linear_scale),
            title: Text('Transaction Max'),
            subtitle: Text(
                "${Money.fromInt(userPF.getUserThreshold, usdCurrency)}"),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return ThresholdDialog(userPF.getUserThreshold);
                  },
                  fullscreenDialog: true
              ));
            },
          );
        }
    );
  }

  Widget _monthlyLimit() {
    return Consumer<UserProfileModel>(
        builder: (context, userPF, child) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
            leading: Icon(Icons.call_made),
            title: Text('Monthly Limit'),
            subtitle: Text(
                userPF.getUserMonthlyLimit == 0 ? "Turned off" : "${Money
                    .fromInt(userPF.getUserMonthlyLimit, usdCurrency)}"),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return MonthlyLimit(userPF.getUserMonthlyLimit);
                  },
                  fullscreenDialog: true
              ));
            },
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLight = MediaQuery
        .of(context)
        .platformBrightness == Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isLight ? Colors.grey[50] : Colors.grey[850],
      systemNavigationBarIconBrightness: isLight ? Brightness.dark : Brightness
          .light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
      statusBarBrightness: isLight ? Brightness.dark : Brightness.light,
    ));

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Material(
        child: SlideTransition(
          position: _paintAn,
          child: CustomPaint(
            painter: ChangeProfilePaint(),
            child: SafeArea(
              child: SlideTransition(
                position: _contentAn,
                child: ListView(
                  children: [
                    SlideTransition(
                      position: _topAn,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _backButton(),
                          _settingsButton(),
                        ],
                      ),
                    ),
                    _nameAndDate(),
                    Divider(),
                    _org(),
                    Divider(),
                    _paymentMethod(),
                    _roundUpAccounts(),
                    Divider(),
                    _transactionMax(),
                    _monthlyLimit(),
                  ],
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
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    _returnHome();
    return false;
  }

  void _returnHome() async {
    await _controller.animateBack(0, duration: Duration(milliseconds: 600));
    Navigator.pushAndRemoveUntil(
        context, PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage()), (
        route) => false);
  }
}
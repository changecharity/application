import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';

class UserProfileModel extends ChangeNotifier {
  String _userPfLetter = "";
  String _userName = "";
  String _doSU = "";
  int _threshold = 100;
  int _monthlyLimit = 0;
  bool _roundUpStatus = true;
  Money _monthTotal = Money.fromInt(0, Currency.create('USD', 2));
  Money _weekTotal = Money.fromInt(0, Currency.create('USD', 2));

  String get getUserPfLetter => _userPfLetter;

  String get getUserName => _userName;

  String get getDoSU => _doSU;

  int get getUserThreshold => _threshold;

  int get getUserMonthlyLimit => _monthlyLimit;

  bool get getUserRoundUpStatus => _roundUpStatus;

  Money get getMonthTotal => _monthTotal;

  Money get getWeekTotal => _weekTotal;

  void notify(
      String pfLetter, String name, String doSU, int thresh, int ml, bool rus) {
    _userPfLetter = _checkPL(pfLetter);
    _userName = name;
    _doSU = _checkDoSU(doSU);
    _threshold = thresh;
    _monthlyLimit = ml ?? 0;
    _roundUpStatus = rus ?? false;
    notifyListeners();
  }

  void notifyTotals(int month, int week) {
    _monthTotal = Money.fromInt(month, Currency.create('USD', 2));
    _weekTotal = Money.fromInt(week, Currency.create('USD', 2));
    notifyListeners();
  }

  String _checkPL(String pl) {
    pl ??= "A";
    return pl.toUpperCase();
  }

  String _checkDoSU(String d) {
    d ??= "";

    if (d == "") {
      return _doSU;
    }

    d = d.substring(0, 10);
    var r = DateTime.parse(d);
    var e = DateFormat.MMMM().format(r);
    return "$e, ${r.year}";
  }
}

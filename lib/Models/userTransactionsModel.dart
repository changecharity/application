import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTransactionsModel extends ChangeNotifier {
  List _transactions = [];

  List get getTransactions => _transactions;

  void notify(List trans) {
    _transactions = trans ??= [];
    notifyListeners();
  }

  void addTrans(List trans) {
    if(trans == null || trans == []) {
      return;
    }
    _transactions += trans;
    notifyListeners();
  }
}
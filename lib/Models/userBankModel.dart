import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserBankModel extends ChangeNotifier{
  String _mask="";
  String _bankName="";

  String get getMask=>_mask;
  String get getBankName=> _bankName;

  void notify(String mask, String name){
    _mask=mask;
    _bankName=name;
    notifyListeners();
  }
}
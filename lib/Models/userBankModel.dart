import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserBankModel extends ChangeNotifier{
  String _mask="";
  String _bankName="";
  String _pfLetter="";

  String get getMask=>_mask;
  String get getBankName=> _bankName;
  String get getPfLetter=> _pfLetter;

  void notify(String mask, String name, String pfLetter){
    _mask=mask;
    _bankName=name;
    _pfLetter=pfLetter;
    notifyListeners();
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserBankModel extends ChangeNotifier{
  String _mask="";
  String _bankName="";
  String _pfLetter="";
  List _cards = [];

  String get getMask=>_mask;
  String get getBankName=> _bankName;
  String get getPfLetter=> _pfLetter;
  List get getCards=> _cards;

  void notify(String mask, String name, String pfLetter, List cards){
    _mask=mask;
    _bankName=name;
    _pfLetter=pfLetter;
    _cards= cards == null ? [] : cards;
    notifyListeners();
  }
}
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
    _bankName=name == null ? null : titleCase(name);
    _pfLetter=pfLetter;
    _cards= cards == null ? [] : cards;
    notifyListeners();
  }
}

/// My way of capitalizing each word in a string.
String titleCase(String text) {
  if (text == null) throw ArgumentError("string: $text");

  if (text.isEmpty) return text;

  /// If you are careful you could use only this part of the code as shown in the second option.
  return text
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}
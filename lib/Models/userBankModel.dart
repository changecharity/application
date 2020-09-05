import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserBankModel extends ChangeNotifier {
  String _mask = "";
  String _bankName = "";
  List _cards = [];

  String get getMask => _mask;

  String get getBankName => _bankName;

  List get getCards => _cards;

  void notify(String mask, String name, List cards) {
    _mask = convertMask(mask);
    _bankName = name == null ? null : titleCase(name);
    _cards = cards == null ? [] : cards;
    notifyListeners();
  }
}

/// My way of capitalizing each word in a string.
String titleCase(String text) {
  if (text == null) throw ArgumentError("string: $text");
  if (text.isEmpty) return text;
  return text
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

String convertMask(String mask) {
  if (mask == null) {
    mask = "0";
  }
  for (var i = 0; i < 4 - mask.length; i++) {
    mask = "0" + mask;
  }
  return mask;
}

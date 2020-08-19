import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfileModel extends ChangeNotifier{
  String _userPfLetter= "";
  String _userName="";
  int _threshold = 100;
  int _monthlyLimit = 0;
  bool _roundUpStatus = true;

  String get getUserPfLetter=>_userPfLetter;
  String get getUserName=> _userName;
  int get getUserThreshold => _threshold;
  int get getUserMonthlyLimit=> _monthlyLimit;
  bool get getUserRoundUpStatus=> _roundUpStatus;

  void notify(String pfLetter, String name, int thresh, int ml, bool rus) {
    _userPfLetter = pfLetter.toUpperCase();
    _userName = name;
    _threshold = thresh;
    _monthlyLimit = ml == null ? 0 : ml;
    _roundUpStatus = rus;
    notifyListeners();
  }
}

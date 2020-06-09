import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserBankModel extends ChangeNotifier{
    int _mask=0;
    String _bankName="";

    int get getMask=>_mask;
    String get getBankName=_bankName;

    void notify(int mask, String name){
        _mask=mask;
        _bankName=name;
        notifyListeners();
    }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserOrgModel extends ChangeNotifier{
   String _userOrg= "";
   String _userOrgImg="https://wallpaperplay.com/walls/full/b/d/1/58065.jpg";

   String get getUserOrg=>_userOrg;
   String get getOrgImg=> _userOrgImg;

   void notify(String name, String img) {
     _userOrg = name;
     _userOrgImg = img;
     notifyListeners();
   }


}

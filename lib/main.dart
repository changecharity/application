import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import'././Services/service_locator.dart';

import 'package:change/Models/userOrgModel.dart';
import 'package:change/Models/userBankModel.dart';


//Future<void> main() async {
//  WidgetsFlutterBinding.ensureInitialized();
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  name = prefs.getString("email");
//  initScreen = name != null ? true : false;
//  runApp(SolasOpapp(
//    initScreen,
//  ));
//}
Future<void> main() async {
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  var initScreen = token != null ? true : false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserOrgModel()),
        ChangeNotifierProvider(create: (context) => UserBankModel()),
      ],
      child:Change(initScreen)
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import'././Services/service_locator.dart';

import 'package:change/Models/userOrgModel.dart';
import 'package:change/Models/userBankModel.dart';


void main() {
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserOrgModel()),
        ChangeNotifierProvider(create: (context) => UserBankModel()),
      ],
      child:Change()
    ),
  );
}
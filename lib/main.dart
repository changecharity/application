import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import'././Services/service_locator.dart';

import 'homePage.dart';


void main() {
  setupLocator();
  runApp(
    ChangeNotifierProvider(
      create:(context)=>UserOrgModel(),
      child:Change()
    )
  );
}
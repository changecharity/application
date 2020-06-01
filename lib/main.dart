import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import'././Services/service_locator.dart';

import 'package:change/UserOrgModel.dart';


void main() {
  setupLocator();
  runApp(
    ChangeNotifierProvider<UserOrgModel>(
      create:(context)=>UserOrgModel(),
      child:Change()
    )
  );
}
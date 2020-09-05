import 'package:change/Models/userBankModel.dart';
import 'package:change/Models/userOrgModel.dart';
import 'package:change/Models/userProfileModel.dart';
import 'package:change/Models/userTransactionsModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => UserOrgModel()),
      ChangeNotifierProvider(create: (context) => UserBankModel()),
      ChangeNotifierProvider(create: (context) => UserProfileModel()),
      ChangeNotifierProvider(create: (context) => UserTransactionsModel()),
    ], child: Change()),
  );
}

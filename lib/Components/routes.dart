import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';

import '../Models/userBankModel.dart';
import '../Models/userTransactionsModel.dart';
import '../Models/userProfileModel.dart';
import '../Pages/login.dart';

class Routes {
    Routes({
        @required this.context,
    });

    final BuildContext context;

    GlobalConfiguration cfg = new GlobalConfiguration();
    String token;

    //call at initState to get user's max threshold, last 4 digits, and bank name
    getProfileDetails() async {
        token ?? await _getToken();

        var content = '{"user_token":"$token"}';
        var profileRes = await http.post("${cfg.getString("host")}/users/getprofile", body: content);

        // if there is no token, or token is wrong, log the user out.
        if(profileRes.body.contains("no rows in result set")){
            _logOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
            return;
        }

        var res = jsonDecode(profileRes.body);

        //notify provider
        context.read<UserBankModel>().notify(res["mask"].toString(), res["bank_name"], res["cards"]);
        context.read<UserProfileModel>().notify(res["legal_name"][0], res["legal_name"], res["threshold"], res["monthly_limit"], res["round_up_status"]);
        context.read<UserProfileModel>().notifyTotals(res["monthly_total"], res["weekly_total"]);
        context.read<UserTransactionsModel>().notify(res["transactions"]);
    }

    Future<void> _getToken() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        token = prefs.getString('token');
    }

    Future<void> _logOut() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', null);
    }

}
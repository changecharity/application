import 'dart:convert';

import 'package:change/Models/userOrgModel.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/userBankModel.dart';
import '../Models/userProfileModel.dart';
import '../Models/userTransactionsModel.dart';
import '../splash.dart';

class Routes {
  Routes({
    @required this.context,
  });

  final BuildContext context;

  GlobalConfiguration cfg = new GlobalConfiguration();
  String token;

  //call at initState to get user's max threshold, last 4 digits, and bank name
  void getProfileDetails() async {
    token ?? await _getToken();

    var content = '{"user_token":"$token"}';
    var profileRes = await http
        .post("${cfg.getString("host")}/users/getprofile", body: content);

    // if there is no token, or token is wrong, log the user out.
    if (profileRes.body.contains("no rows in result set")) {
      logOut();
      return;
    }

    var res = jsonDecode(profileRes.body);
    print("user's profile is: $res");

    //notify provider
    context
        .read<UserBankModel>()
        .notify(res["mask"].toString(), res["bank_name"], res["cards"]);
    context.read<UserProfileModel>().notify(
        res["legal_name"][0],
        res["legal_name"],
        res["dosu"],
        res["threshold"],
        res["monthly_limit"],
        res["status"]);
    context
        .read<UserProfileModel>()
        .notifyTotals(res["monthly_total"], res["weekly_total"]);
    context.read<UserTransactionsModel>().notify(res["transactions"]);
  }

  void getOrgDetails() async {
    token ?? await _getToken();

    //get user's org info
    var content = '{"user_token":"$token"}';
    var orgRes = await http.post(
      "${cfg.getString("host")}/users/getusersorginfo",
      body: content,
    );

    var res = jsonDecode(orgRes.body);
    print("org info is: $res");

    //set org name and org image in provider
    context.read<UserOrgModel>().notify(res["name"], res["logo_location"]);
  }

  void getMoreTrans(int offset) async {
    token ?? await _getToken();

    //get user's transactions
    var content = '{"user_token":"$token", "offset":$offset}';
    var transactionResponse = await http.post(
      "${cfg.getString("host")}/users/gettransactions",
      body: content,
    );

    // Update provider with additional routes
    context
        .read<UserTransactionsModel>()
        .addTrans(jsonDecode(transactionResponse.body));
  }

  void setThreshold(int thresh) async {
    token ?? await _getToken();

    context.read<UserProfileModel>().notify(
        context.read<UserProfileModel>().getUserPfLetter,
        context.read<UserProfileModel>().getUserName,
        "",
        thresh,
        context.read<UserProfileModel>().getUserMonthlyLimit,
        context.read<UserProfileModel>().getUserRoundUpStatus);

    var content = '{"user_token":"$token", "threshold":$thresh}';
    var threshRes = await http
        .post("${cfg.getString("host")}/users/updatethreshold", body: content);

    print("threshold res status: ${threshRes.body}");
    print(thresh);
  }

  void setMonthlyLimit(int limit) async {
    token ?? await _getToken();

    context.read<UserProfileModel>().notify(
        context.read<UserProfileModel>().getUserPfLetter,
        context.read<UserProfileModel>().getUserName,
        "",
        context.read<UserProfileModel>().getUserThreshold,
        limit,
        context.read<UserProfileModel>().getUserRoundUpStatus);

    var content = '{"user_token":"$token", "monthly_limit":$limit}';
    var monthlyRes = await http.post(
        "${cfg.getString("host")}/users/updatemonthlylimit",
        body: content);

    print("monthly limit update res status: ${monthlyRes.body}");
    print("new limit is: $limit");
  }

  void setRUStatus(bool status) async {
    token ?? await _getToken();

    context.read<UserProfileModel>().notify(
        context.read<UserProfileModel>().getUserPfLetter,
        context.read<UserProfileModel>().getUserName,
        "",
        context.read<UserProfileModel>().getUserThreshold,
        context.read<UserProfileModel>().getUserMonthlyLimit,
        status);

    var content = '{"user_token":"$token", "status":$status}';
    var rUStatus = await http.post(
        "${cfg.getString("host")}/users/updateroundupstatus",
        body: content);

    print("round-up res status: ${rUStatus.body}");
    print(status);
  }

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    if (token == "" || token == null) {
      logOut();
    }
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', null);
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => Splash()),
      (route) => false,
    );
  }
}

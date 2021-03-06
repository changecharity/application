import 'package:change_charity_components/change_charity_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'splash.dart';

class Change extends StatefulWidget {
  @override
  _ChangeState createState() => _ChangeState();
}

class _ChangeState extends State<Change> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Change',
      home: Splash(),
      theme: ChangeTheme(isDark: false).themeData,
      darkTheme: ChangeTheme(isDark: true).themeData,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}

final lightTheme = _lightTheme();

ThemeData _lightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: Colors.lightBlue[200],
    primaryColor: Colors.lightBlueAccent[400],
    scaffoldBackgroundColor: Colors.grey[100],
    cardColor: Colors.blueGrey[200],
    textSelectionColor: Colors.lightBlueAccent[100],
    errorColor: Colors.redAccent,
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
        style: BorderStyle.none,
        color: Colors.grey[900],
        width: 1.0,
      )),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          style: BorderStyle.none,
          color: Colors.lightBlueAccent[400],
          width: 2.0,
        ),
      ),
      errorStyle: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          style: BorderStyle.none,
          color: Colors.red,
          width: 0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          style: BorderStyle.none,
          color: Colors.red[600],
          width: 0,
        ),
      ),
    ),
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      textTheme: ButtonTextTheme.normal,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.blueGrey[400],
    ),
    primaryIconTheme: base.iconTheme.copyWith(color: Colors.grey[100]),
    textTheme: _lightTextTheme(base.textTheme),
    primaryTextTheme: _lightTextTheme(base.primaryTextTheme),
    accentTextTheme: _lightTextTheme(base.accentTextTheme),
  );
}

TextTheme _lightTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline5: base.headline5.copyWith(
          fontWeight: FontWeight.w500,
        ),
        headline6: base.headline6.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 12.0,
        ),
        bodyText1: base.bodyText1.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
      )
      .apply(
        fontFamily: 'Montserrat',
        displayColor: Colors.black,
        bodyColor: Colors.black,
      );
}

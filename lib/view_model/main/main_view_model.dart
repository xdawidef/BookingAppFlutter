import 'package:flutter/material.dart';
import 'package:flutter_app/time_description/time_description.dart';

abstract class MainViewModel {
  void processLogin(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey);
  Future<LOGIN_STATE> checkLoginState(BuildContext context, bool fromLogin,
      GlobalKey<ScaffoldState> scaffoldState);

  void logout(BuildContext context);
}
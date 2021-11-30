import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/scaffold.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/fcm/fcm_notification_handler.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/ui/bottom_navbar.dart';
import 'package:flutter_app/ui/components/user_widgets/register_dialog.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/view_model/main/main_view_model.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

class MainViewModelImp implements MainViewModel {
  @override
  Future<LOGIN_STATE> checkLoginState(BuildContext context, bool fromLogin,
      GlobalKey<ScaffoldState> scaffoldState) async {
    if (!context.read(forceReload).state) {
      await Future.delayed(Duration(seconds: fromLogin == true ? 0 : 3))
          .then((value) => {
                FirebaseAuth.instance.currentUser!
                    .getIdToken()
                    .then((token) async {
                  //Force reload state
                  context.read(forceReload).state = true;

                  print('&token');
                  context.read(userToken).state = token;

                  //Check user in Firestore
                  CollectionReference userRef =
                      FirebaseFirestore.instance.collection('User');
                  DocumentSnapshot snapshotUser = await userRef
                      .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                      .get();

                  if (snapshotUser.exists) {

                    //Get token
                    FirebaseMessaging.instance.getToken()
                        .then((value) => print('Token $value'));

                    //Subscribe topic
                    FirebaseMessaging.instance.subscribeToTopic(FirebaseAuth.instance.currentUser!.uid)
                        .then((value) => print('Success'));

                    //Setup message display
                    initFirebaseMessagingHandler(channel!);

                    Navigator.pushNamedAndRemoveUntil(
                         context, '/start', (route) => false);
                  } else {
                    showRegisterDialog(context, userRef, scaffoldState);
                  }
                })
              });
    }
    return FirebaseAuth.instance.currentUser != null
        ? LOGIN_STATE.LOGGED
        : LOGIN_STATE.NOT_LOGIN;
  }

  @override
  processLogin(BuildContext context, GlobalKey<ScaffoldState> scaffoldState) {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      FlutterAuthUi.startUi(
              items: [AuthUiProvider.phone],
              tosAndPrivacyPolicy: TosAndPrivacyPolicy(
                  tosUrl: 'https://google.com',
                  privacyPolicyUrl: 'https://google.com'),
              androidOption: AndroidOption(
                  enableSmartLock: false, showLogo: true, overrideTheme: true))
          .then((value) async {
        //Refresh state
        context.read(userLogged).state = FirebaseAuth.instance.currentUser;

        //Start screen
        await checkLoginState(context, true, scaffoldState);
      }).catchError((e) {
        ScaffoldMessenger.of(scaffoldState.currentContext!)
            .showSnackBar(SnackBar(content: Text('${e.toString()}')));
      });
    }
  }

  @override
  void logout(BuildContext context) async{
    await  FirebaseAuth.instance.signOut().then((value) => {
          context.read(forceReload).state = false,
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false)
        });
  }
}

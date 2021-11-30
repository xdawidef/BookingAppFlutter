import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/fcm/fcm_notification_handler.dart';
import 'package:flutter_app/ui/login_page/theme.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/view_model/main/main_view_model_imp.dart';

import '../../main.dart';

// class LoginPageScreen extends StatefulWidget {
//   final scaffoldState = new GlobalKey<ScaffoldState>();
//   final mainViewModel = MainViewModelImp();
//
//   @override
//   LoginPageScreen createState() => LoginPageScreenState();
//
// }

class LoginPageScreenState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: widget.scaffoldState,
        backgroundColor: greenColor,
        body: SafeArea(
          bottom: false,
          child: Container(
            child: FutureBuilder(
                future: widget.mainViewModel
                    .checkLoginState(context, false, widget.scaffoldState),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    else {
                      return Stack(
                        children: [

                          Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Image.asset(
                                    'assets/images/signup.png',
                                    width: 350,
                                  ),
                                ),
                                Text(
                                  'Hello!',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 24,
                                    fontWeight: medium,
                                  ),
                                ),
                                Text(
                                  'Click on the button and log in to your account\n to book your services',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: light,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -40,
                            right: -60,
                            child: Image.asset('assets/images/image_hand2.png',
                              width: 250,),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  //color: yellowColor,
                                  padding: const EdgeInsets.only(bottom: 50),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          widget.mainViewModel.processLogin(context, widget.scaffoldState);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 58,
                                            vertical: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: yellowColor,
                                            borderRadius: BorderRadius.horizontal(
                                              right: Radius.circular(20),
                                            ),
                                          ),
                                          child: Text(
                                            'Login via Phone',
                                            style: blackTextStyle.copyWith(
                                                fontSize: 18, fontWeight: medium),
                                          ),

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    }
                ),
          ),
        ));
  }
}

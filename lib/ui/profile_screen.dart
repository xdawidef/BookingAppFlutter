import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/login_page/theme.dart';
import 'package:flutter_app/ui/profile_body.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navbar.dart';

class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      drawer: NavBar(),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            title: Text('Profile',
                style:
                greenTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
            actions: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Text('Edit', style: TextStyle(color: greenColor, fontSize: 15)),
              ),
            ],
            centerTitle: true,
            backgroundColor: yellowColor,
            iconTheme: IconThemeData(color: greenColor),
          )),
      body: ProfileBody(),
      backgroundColor: greenColor,
    );
  }
}

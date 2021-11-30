import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/cloud_firestore/banner_ref.dart';
import 'package:flutter_app/cloud_firestore/lookbook_ref.dart';
import 'package:flutter_app/cloud_firestore/user_ref.dart';
import 'package:flutter_app/model/image_model.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/view_model/home/home_view_model.dart';
import 'package:flutter_app/view_model/home/home_view_model_imp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page/theme.dart';
import 'navbar.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final homeViewModel = HomeViewModelImp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            title: Text('Home',
                style: yellowTextStyle.copyWith(
                    fontSize: 18, fontWeight: medium)),
            centerTitle: true,
            backgroundColor: greenColor,
            iconTheme: IconThemeData(color: yellowColor),
          )),
      backgroundColor: greenColor,

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 25,
              bottom: 32,
              left: 25,
              right: 32,
            ),
            child: Stack(
              children: [
                FutureBuilder(
                    future: homeViewModel.displayUserProfile(
                        context, FirebaseAuth.instance.currentUser!.phoneNumber!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      else {
                        var userModel = snapshot.data as UserModel;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Hi ${userModel.name}',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800,
                                        color: yellowColor),
                                  ),
                                  TextSpan(

                                    text: (homeViewModel.isStaff(context) ? '\nReady for another working day?' : '\nReady to book a service?'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: redColor),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                      child: ClipOval(
                                        child: Image.network(
                                          '${userModel.profileImage}',
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                   // Image.asset('assets/images/avatar2.png'),
                                    Positioned(
                                      top: -6,
                                      right: 6,
                                      child: Container(
                                        height: 13,
                                        width: 13,
                                        decoration: BoxDecoration(
                                          color: redColor,
                                          borderRadius: BorderRadius.circular(17),
                                          border: Border.all(
                                            width: 1,
                                            color: whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        );
                      }
                    }),
              ],
            ),
          ),
          FutureBuilder(
              future: homeViewModel.displayBanner(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  var banners = snapshot.data as List<ImageModel>;
                  return CarouselSlider(
                      options: CarouselOptions(
                          enlargeCenterPage: true,
                          aspectRatio: 3.0,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3)),
                      items: banners
                          .map((e) =>
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.network(e.image),
                            ),
                          ))
                          .toList());
                }
              }),
        ],
      ),
    );




  }

  // BottomNavigationBarItem buildBottomNavigationBarItem(
  //     IconData image, int index, String desc) {
  //   return BottomNavigationBarItem(
  //     icon: Column(
  //       children: [
  //         Icon(
  //           image,
  //           size: 20,
  //         ),
  //       ],
  //     ),
  //     title: Text(
  //       desc,
  //       style: TextStyle(fontSize: 12),
  //     ),
  //   );
  // }
}



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/booking_screen.dart';
import 'package:flutter_app/ui/home_screen.dart';
import 'package:flutter_app/ui/profile_screen.dart';
import 'package:flutter_app/ui/user_history_screen.dart';

import 'login_page/theme.dart';

class BottomNavBar extends StatefulWidget {
  int currentIndex = 0;

  BottomNavBar(this.currentIndex);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> _children = [
    HomePage(),
    BookingScreen(),
    UserHistory(),
    ProfileScreen(),
  ];

  void onTapTapped(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenColor,
      body: _children[widget.currentIndex],
      bottomNavigationBar: Container(
        height: 55,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: blackColor.withOpacity(0.2),
          elevation: 0.0,
          selectedItemColor: yellowColor,
          unselectedItemColor: greyColor,
          onTap: onTapTapped,
          currentIndex: widget.currentIndex,
          items: [
            buildBottomNavigationBarItem(Icons.home, 0, 'Home'),
            buildBottomNavigationBarItem(Icons.book_online, 1, 'Booking'),
            buildBottomNavigationBarItem(Icons.history, 2, 'History'),
            buildBottomNavigationBarItem(Icons.settings, 3, 'Profile'),

          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      IconData image, int index, String desc) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Icon(
            image,
            size: 20,
          ),
        ],
      ),
      title: Text(
        desc,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}

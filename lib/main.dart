import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/fcm/fcm_background_handler.dart';
import 'package:flutter_app/fcm/fcm_notification_handler.dart';
import 'package:flutter_app/intro/intro.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/ui/booking_screen.dart';
import 'package:flutter_app/ui/bottom_navbar.dart';
import 'package:flutter_app/ui/done_services_screens.dart';
import 'package:flutter_app/ui/home_screen.dart';
import 'package:flutter_app/ui/login_page/login_page_screen.dart';
import 'package:flutter_app/ui/navbar.dart';
import 'package:flutter_app/ui/staff_home_screen.dart';
import 'package:flutter_app/ui/user_history_screen.dart';
import 'package:flutter_app/ui/worker_booking_history_screen.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/view_model/main/main_view_model_imp.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
AndroidNotificationChannel? channel;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //await fix login null;

  //Setup Firebase
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  //Flutter Local Notifications
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  channel = const AndroidNotificationChannel(
      'booking', 'Booking app',
      importance: Importance.max);
  await flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true
  );


  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),

      title: 'Flutter Demo',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageTransition(
                settings: settings,
                child: HomePage(),
                type: PageTransitionType.fade);
          case '/doneService':
            return PageTransition(
                settings: settings,
                child: DoneService(),
                type: PageTransitionType.fade);
          case '/staffHome':
            return PageTransition(
                settings: settings,
                child: StaffHome(),
                type: PageTransitionType.fade);
          case '/history':
            return PageTransition(
                settings: settings,
                child: UserHistory(),
                type: PageTransitionType.fade);
          case '/booking':
            return PageTransition(
                settings: settings,
                child: BookingScreen(),
                type: PageTransitionType.fade);
          case '/bookingHistory':
            return PageTransition(
                settings: settings,
                child: WorkerHistoryScreen(),
                type: PageTransitionType.fade);
          case '/intro':
            return PageTransition(
                settings: settings,
                child: IntroScreen(),
                type: PageTransitionType.fade);
          case '/start':
            return PageTransition(
                settings: settings,
                child: BottomNavBar(0),
                type: PageTransitionType.fade);

          default:
            return null;
        }
      },
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final scaffoldState = new GlobalKey<ScaffoldState>();
  final mainViewModel = MainViewModelImp();

  @override
  LoginPageScreenState createState() => LoginPageScreenState();


}

// class MyHomePageState extends State<MyHomePage> {
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //
//   //   // //Get token
//   //   // FirebaseMessaging.instance.getToken()
//   //   //     .then((value) => print('Token $value'));
//   //   //
//   //   // //Subscribe topic
//   //   // FirebaseMessaging.instance.subscribeToTopic(FirebaseAuth.instance.currentUser!.uid)
//   //   //     .then((value) => print('Success'));
//   //   //
//   //   // //Setup message display
//   //   // initFirebaseMessagingHandler(channel!);
//   //
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return SafeArea(
//         child: Scaffold(
//           key: widget.scaffoldState,
//           body: Container(
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage('assets/images/my_bg.png'),
//                     fit: BoxFit.cover)),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   width: MediaQuery.of(context).size.width,
//                   child: FutureBuilder(
//                       future: widget.mainViewModel.checkLoginState(
//                           context, false, widget.scaffoldState),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.waiting)
//                           return Center(
//                             child: CircularProgressIndicator(),
//
//                           );
//                         else {
//                           var userState = snapshot.data! as LOGIN_STATE;
//                            if (userState == LOGIN_STATE.LOGGED) {
//                              return ElevatedButton.icon(
//                                onPressed: () =>
//                                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
//                                icon: Icon(Icons.phone, color: Colors.white),
//                                label: Text(
//                                  'Login',
//                                  style: TextStyle(color: Colors.white),
//                                ),
//                                style: ButtonStyle(
//                                    backgroundColor:
//                                    MaterialStateProperty.all(Colors.black)),
//                              );
//                               }
//                         else {
//                           //If user not login
//                           return ElevatedButton.icon(
//                             onPressed: () =>
//                                 widget.mainViewModel.processLogin(context, widget.scaffoldState),
//                             icon: Icon(Icons.phone, color: Colors.white),
//                             label: Text(
//                               'Login by phone',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             style: ButtonStyle(
//                                 backgroundColor:
//                                 MaterialStateProperty.all(Colors.black)),
//                           );
//                         }
//                       }}),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
//
// }

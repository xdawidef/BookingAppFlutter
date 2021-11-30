import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_app/cloud_firestore/user_ref.dart';
import 'package:flutter_app/model/booking_model.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_app/model/salon_model.dart';
import 'package:flutter_app/model/worker_model.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/ui/navbar.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/view_model/user_history/user_history_view_model.dart';
import 'package:flutter_app/view_model/user_history/user_history_view_model_imp.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'login_page/theme.dart';

class UserHistory extends ConsumerWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userHistoryViewModel = UserHistoryViewModelImp();

  @override
  Widget build(BuildContext context, watch) {
    var watchRefresh = watch(deleteFlagRefresh).state;
    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
          drawer: NavBar(),
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: AppBar(
                title: Text('History',
                    style: yellowTextStyle.copyWith(
                        fontSize: 18, fontWeight: medium)),
                centerTitle: true,
                backgroundColor: greenColor,
                iconTheme: IconThemeData(color: yellowColor),
              )),
          backgroundColor: greenColor,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder(
            future: userHistoryViewModel.displayUserHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                var userBookings = snapshot.data as List<BookingModel>;
                if (userBookings.length == 0)
                  return Center(
                    child: Text('Cannot load booking information'),
                  );
                else {
                  return FutureBuilder(
                      future: syncTime(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        else {
                          var syncTime = snapshot.data as DateTime;

                          return ListView.builder(
                              itemCount: userBookings.length,
                              itemBuilder: (context, index) {
                                var isExpired = DateTime.fromMillisecondsSinceEpoch(
                                    userBookings[index].timeStamp)
                                    .isBefore(syncTime);
                                return Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(22))),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      'Date',
                                                      style:
                                                      GoogleFonts.robotoMono(),
                                                    ),
                                                    Text(
                                                      DateFormat("dd/MM/yy").format(
                                                          DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                              userBookings[
                                                              index]
                                                                  .timeStamp)),
                                                      style: GoogleFonts.robotoMono(
                                                          fontSize: 22,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      'Time',
                                                      style:
                                                      GoogleFonts.robotoMono(),
                                                    ),
                                                    Text(
                                                      TIME_SLOT.elementAt(
                                                          userBookings[index].slot),
                                                      style: GoogleFonts.robotoMono(
                                                          fontSize: 22,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Divider(
                                              thickness: 1.5,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${userBookings[index].salonName}',
                                                      style: GoogleFonts.robotoMono(
                                                          fontSize: 20,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${userBookings[index].workerName}',
                                                      style:
                                                      GoogleFonts.robotoMono(),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  '${userBookings[index].salonAddress}',
                                                  style: GoogleFonts.robotoMono(),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (userBookings[index].done || isExpired)
                                            ? null
                                            : () {
                                          Alert(
                                              context: context,
                                              type: AlertType.warning,
                                              title: 'Delete booking',
                                              desc:
                                              'Remember to delete event from you calendar!',
                                              buttons: [
                                                DialogButton(
                                                  child: Text(
                                                    'Cancel',
                                                    style: GoogleFonts
                                                        .robotoMono(
                                                        color:
                                                        Colors.black),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  color: Colors.white,
                                                ),
                                                DialogButton(
                                                  child: Text(
                                                    'Delete',
                                                    style: GoogleFonts
                                                        .robotoMono(
                                                        color:
                                                        Colors.red),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop();
                                                    userHistoryViewModel.userCancelBooking(context,
                                                        userBookings[index]);
                                                  },
                                                  color: Colors.white,
                                                )
                                              ]).show();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                            userBookings[index].done
                                                ? Colors.green
                                                : isExpired
                                                ? Colors.red
                                                : Colors.blue,
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(22),
                                                bottomLeft: Radius.circular(22)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text(
                                                  userBookings[index].done
                                                      ? 'Finish'
                                                      : isExpired
                                                      ? 'Expired'
                                                      : 'Cancel',
                                                  style: GoogleFonts.robotoMono(
                                                      color: isExpired
                                                          ? Colors.black
                                                          : Colors.white),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        }
                      });
                }
              }
            }),
      ),
    ));
  }


}

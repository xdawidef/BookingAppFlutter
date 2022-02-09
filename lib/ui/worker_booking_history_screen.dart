import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/booking_model.dart';
import 'package:flutter_app/state/staff_user_history_state.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/time_description/time_description.dart';
import 'package:flutter_app/view_model/worker_booking_history/worker_booking_history_view_model_imp.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'login_page/theme.dart';

class WorkerHistoryScreen extends ConsumerWidget {
  final workerHistoryViewModel = WorkerBookingHistoryViewModelImp();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var dateWatch = watch(workerHistorySelectedDate).state;
    return SafeArea(
        child: Scaffold(
      backgroundColor: greenColor,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: AppBar(
                title: Text('Staff history',
                    style: yellowTextStyle.copyWith(
                        fontSize: 18, fontWeight: medium)),
                centerTitle: true,
                backgroundColor: greenColor,
                iconTheme: IconThemeData(color: yellowColor),
              )),
      body: Column(
        children: [
          Container(
              color: lessDarkGreenColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text(
                              '${DateFormat.MMMM().format(dateWatch)}',
                              style:
                              yellowTextStyle.copyWith(
                                  fontSize: 16, fontWeight: medium),
                            ),
                            Text(
                              '${dateWatch.day}',
                              style:
                              yellowTextStyle.copyWith(
                                  fontSize: 20, fontWeight: medium),
                            ),
                            Text(
                              '${DateFormat.EEEE().format(dateWatch)}',
                              style:
                              yellowTextStyle.copyWith(
                                  fontSize: 16, fontWeight: medium),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          onConfirm: (date) => context
                              .read(workerHistorySelectedDate)
                              .state = date);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.calendar_today, color: yellowColor),
                      ),
                    ),
                  )
                ],
              )),
          Expanded(child: FutureBuilder(
              future: workerHistoryViewModel.getWorkerBookingHistory(
                  context, dateWatch),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  var userBookings = snapshot.data as List<BookingModel>;
                  if (userBookings.length == 0)
                    return Center(
                      child: Text('You have not booking in this day'),
                    );
                  else {
                    return FutureBuilder(
                        future: synchroTime(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          else {
                            var syncTime = snapshot.data as DateTime;

                            return ListView.builder(
                                itemCount: userBookings.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: greyColor,
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(22))),
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
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        'Date:',
                                                        style: yellowRobotoTextStyle.copyWith(
                                                            fontSize: 15, fontWeight: medium),
                                                      ),
                                                      Text(
                                                        DateFormat("dd/MM/yy")
                                                            .format(DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                            userBookings[
                                                            index]
                                                                .timeStamp)),
                                                        style: yellowRobotoTextStyle.copyWith(
                                                            fontSize: 20, fontWeight: bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        'Time:',
                                                        style: yellowRobotoTextStyle.copyWith(
                                                            fontSize: 15, fontWeight: medium),
                                                      ),
                                                      Text(
                                                        TIME_SLOT.elementAt(
                                                            userBookings[index]
                                                                .slot),
                                                        style: yellowRobotoTextStyle.copyWith(
                                                            fontSize: 20, fontWeight: bold),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Divider(
                                                thickness: 1,
                                                color: yellowColor,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
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
                                                        style: yellowRobotoTextStyle.copyWith(
                                                            fontSize: 20, fontWeight: bold),
                                                      ),
                                                      Text(
                                                        '${userBookings[index].workerName}',
                                                        style: yellowRobotoTextStyle.copyWith(
                                                            fontSize: 15, fontWeight: medium),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${userBookings[index].salonAddress}',
                                                        style: yellowRobotoTextStyle.copyWith(
                                                            fontSize: 15, fontWeight: medium),
                                                      ),
                                                      Text(
                                                        'Finished: ${userBookings[index].done}',
                                                        style: yellowRobotoTextStyle.copyWith(
                                                            fontSize: 15, fontWeight: medium),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }
                        });
                  }
                }
              }),)
        ],
      ),
    ));
  }
}

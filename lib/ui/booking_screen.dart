import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_app/model/booking_model.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_app/model/salon_model.dart';
import 'package:flutter_app/model/worker_model.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/view_model/booking/booking_view_model_imp.dart';
import 'package:flutter_app/widgets/my_loading_widget.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';

import 'components/user_widgets/city_list.dart';
import 'components/user_widgets/confirm.dart';
import 'components/user_widgets/salon_list.dart';
import 'components/user_widgets/time_slot.dart';
import 'components/user_widgets/worker_list.dart';
import 'login_page/theme.dart';
import 'navbar.dart';

class BookingScreen extends ConsumerWidget {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final bookingViewModel = new BookingViewModelImp();

  @override
  Widget build(BuildContext context, watch) {
    var step = watch(currentStep).state;
    var cityWatch = watch(selectedCity).state;
    var salonWatch = watch(selectedSalon).state;
    var workerWatch = watch(selectedWorker).state;
    var dateWatch = watch(selectedDate).state;
    var timeWatch = watch(selectedTime).state;
    var timeSlotWatch = watch(selectedTimeSlot).state;
    var isLoadingWatch = watch(isLoading).state;

    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
          drawer: NavBar(),
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: AppBar(
                title: Text('Booking',
                    style: yellowTextStyle.copyWith(
                        fontSize: 18, fontWeight: medium)),
                centerTitle: true,
                backgroundColor: greenColor,
                iconTheme: IconThemeData(color: yellowColor),
              )),
          backgroundColor: greenColor,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          //Step
          NumberStepper(
            activeStep: step - 1,
            direction: Axis.horizontal,
            enableNextPreviousButtons: false,
            enableStepTapping: false,
            numbers: [1, 2, 3, 4, 5],
            stepColor: yellowColor,
            activeStepColor: redColor,
            numberStyle: TextStyle(color: greenColor),
          ),
          //Screen
          Expanded(
            flex: 10,
            child: step == 1
                ? displayCityList(bookingViewModel)
                : step == 2
                    ? displaySalon(bookingViewModel, cityWatch.name)
                    : step == 3
                        ? displayWorker(bookingViewModel, salonWatch)
                        : step == 4
                            ? displayTimeSlot(bookingViewModel, context, workerWatch)
                            : step == 5
                                ? isLoadingWatch ? MyLoadingWidget(text: 'We are setting up your booking!') : displayConfirm(bookingViewModel, context, scaffoldKey)
                                : Container(),
          ),
          //Button
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: yellowColor,
                          ),
                      onPressed: step == 1
                          ? null
                          : () => context.read(currentStep).state--,
                      child: Text('Previous', style:
                      greenTextStyle.copyWith(fontSize: 15, fontWeight: regular),),
                    )),
                    SizedBox(width: 30),
                    Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: yellowColor,
                          ),
                      onPressed: (step == 1 &&
                                  context.read(selectedCity).state.name.length == 0) ||
                              (step == 2 &&
                                  context
                                          .read(selectedSalon)
                                          .state
                                          .docId!.length == 0) ||
                              (step == 3 &&
                                  context.read(selectedWorker).state.docId!.length == 0) ||
                              (step == 4 &&
                                  context.read(selectedTimeSlot).state == -1)
                          ? null
                          : step == 5
                              ? null
                              : () => context.read(currentStep).state++,
                      child: Text('Next', style:
                      greenTextStyle.copyWith(fontSize: 15, fontWeight: regular),),
                    )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }











}

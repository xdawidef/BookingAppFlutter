import 'package:carousel_slider/carousel_slider.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/cloud_firestore/salons_ref.dart';
import 'package:flutter_app/cloud_firestore/carousel_ref.dart';
import 'package:flutter_app/cloud_firestore/gallery_ref.dart';
import 'package:flutter_app/cloud_firestore/services_ref.dart';
import 'package:flutter_app/cloud_firestore/user_ref.dart';
import 'package:flutter_app/model/booking_model.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_app/model/image_model.dart';
import 'package:flutter_app/model/salon_model.dart';
import 'package:flutter_app/model/service_model.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/string/strings.dart';
import 'package:flutter_app/time_description/time_description.dart';
import 'package:flutter_app/view_model/done_service/done_service_view_model.dart';
import 'package:flutter_app/view_model/done_service/done_service_view_model_imp.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'login_page/theme.dart';

class DoneService extends ConsumerWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final doneServiceViewModel = DoneServiceViewModelImp();
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");

  @override
  Widget build(BuildContext context, watch) {
    context.read(selectedServices).state.clear();
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: greenColor,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: AppBar(
              title: Text('Services',
                  style: yellowTextStyle.copyWith(
                      fontSize: 18, fontWeight: medium)),
              centerTitle: true,
              backgroundColor: greenColor,
              iconTheme: IconThemeData(color: yellowColor),
            )),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: FutureBuilder(
                future: doneServiceViewModel.displayDetailBooking(
                    context, context.read(selectedTimeSlot).state),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else {
                    var bookingModel = snapshot.data as BookingModel;
                    return Card(
                      elevation: 8,
                      color: lessDarkGreenColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  child: Icon(Icons.account_box_rounded,
                                      color: yellowColor),
                                  backgroundColor: darkGreenColor,
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${bookingModel.customerName}',
                                      style: yellowTextStyle.copyWith(
                                          fontSize: 20, fontWeight: medium),
                                    ),
                                    Text(
                                      '${bookingModel.customerPhone}',
                                      style: yellowTextStyle.copyWith(
                                          fontSize: 18, fontWeight: regular),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              thickness: 1.5,
                              color: yellowColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Consumer(builder: (context, watch, _) {
                                  var servicesSelected =
                                      watch(selectedServices).state;

                                  return Text(
                                    'Price: ${context.read(selectedBooking).state.totalPrice == 0 ? '${formatCurrency.format(doneServiceViewModel.calculateTotalPrice(servicesSelected))}' : context.read(selectedBooking).state.totalPrice} PLN',
                                    style: yellowTextStyle.copyWith(
                                        fontSize: 22, fontWeight: regular),
                                  );
                                }),
                                context.read(selectedBooking).state.done
                                    ? Chip(
                                        label: Text('Finished'),
                                        labelStyle: greenTextStyle.copyWith(
                                            fontSize: 15, fontWeight: regular),
                                        backgroundColor: yellowColor,
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: FutureBuilder(
                    future: doneServiceViewModel.displayServices(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      else {
                        var services = snapshot.data as List<ServiceModel>;
                        return Consumer(builder: (context, watch, _) {
                          var servicesWatch = watch(selectedServices).state;
                          return SingleChildScrollView(
                              child: Column(
                            children: [
                              ChipsChoice<ServiceModel>.multiple(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                wrapped: true,
                                value: servicesWatch,
                                onChanged: (val) =>
                                    context.read(selectedServices).state = val,
                                choiceStyle: C2ChoiceStyle(
                                  labelStyle: greenTextStyle.copyWith(
                                      fontSize: 15, fontWeight: medium),
                                  color: yellowColor,
                                  brightness: Brightness.dark,
                                  showCheckmark: false,
                                ),
                                choiceItems: C2Choice.listFrom<ServiceModel,
                                        ServiceModel>(
                                    source: services,
                                    value: (index, value) => value,
                                    label: (index, value) =>
                                        '${value.name} - (${formatCurrency.format(value.price)} PLN)',
                                    style: (index, value) {
                                      return const C2ChoiceStyle(
                                        color: Colors.black54,
                                      );
                                    }),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: yellowColor,
                                  ),
                                  onPressed:
                                      doneServiceViewModel.isDone(context)
                                          ? null
                                          : servicesWatch.length > 0
                                              ? () => doneServiceViewModel
                                                  .finishService(
                                                      context, scaffoldKey)
                                              : null,
                                  child: Text(
                                    'Finish',
                                    style: greenTextStyle.copyWith(
                                        fontSize: 15, fontWeight: regular),
                                  ),
                                ),
                              )
                            ],
                          ));
                        });
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

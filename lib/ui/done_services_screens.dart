import 'package:carousel_slider/carousel_slider.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_app/cloud_firestore/banner_ref.dart';
import 'package:flutter_app/cloud_firestore/lookbook_ref.dart';
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
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/view_model/done_service/done_service_view_model.dart';
import 'package:flutter_app/view_model/done_service/done_service_view_model_imp.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DoneService extends ConsumerWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final doneServiceViewModel = DoneServiceViewModelImp();

  @override
  Widget build(BuildContext context, watch) {
    //When refresh clear selectedServices, because Chip Choices not hold state
   context.read(selectedServices).state.clear();
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFDFDFDF),
        appBar: AppBar(
          title: Text(doneServiceText),
          backgroundColor: Color(0xFF383838),
        ),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  child: Icon(Icons.account_box_rounded,
                                      color: Colors.white),
                                  backgroundColor: Colors.black,
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${bookingModel.customerName}',
                                      style: GoogleFonts.robotoMono(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('${bookingModel.customerPhone}',
                                        style: GoogleFonts.robotoMono(
                                            fontSize: 18))
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Consumer(builder: (context, watch, _) {
                                  var servicesSelected =
                                      watch(selectedServices).state;

                                  return Text(
                                    'Price: ${context.read(selectedBooking).state.totalPrice == 0 ? doneServiceViewModel.calculateTotalPrice(servicesSelected) : context.read(selectedBooking).state.totalPrice} PLN',
                                    style: GoogleFonts.robotoMono(fontSize: 22),
                                  );
                                }),
                                context.read(selectedBooking)
                                .state.done ? Chip(label: Text('Finished'), labelStyle: GoogleFonts.robotoMono(color: Colors.black), backgroundColor: Color(
                                    0xEE4AC619),) : Container()
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
                              // Wrap(
                              //   children: services.map((e) => Padding(
                              //     padding: const EdgeInsets.all(4),
                              //     child: ChoiceChip(
                              //         selected: doneServiceViewModel.isSelectedService(context, e),
                              //         selectedColor: Colors.blue,
                              //         label: Text('${e.name} ${e.price} PLN'),
                              //         labelStyle: TextStyle(color: Colors.white),
                              //         backgroundColor: Colors.teal,
                              //         onSelected: (isSelected) => doneServiceViewModel.onSelectedchip(context, isSelected, e)
                              //         ,
                              //
                              //     ),
                              //   )).toList(),
                              // ),
                              //Select and finish services in done services screen
                              ChipsChoice<ServiceModel>.multiple(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  wrapped: true,
                                  value: servicesWatch,
                                  onChanged: (val) => context
                                      .read(selectedServices)
                                      .state = val,
                                  choiceStyle: C2ChoiceStyle(
                                    color: Colors.blue,
                                    brightness: Brightness.dark,
                                    showCheckmark: true,
                                  ),
                                  choiceItems: C2Choice.listFrom<ServiceModel,
                                      ServiceModel>(
                                      source: services,
                                      value: (index, value) => value,
                                      label: (index, value) => '${value.name} (${value.price} PLN)',
                                    style: (index, value) {
                                      return const C2ChoiceStyle(
                                          color: Colors.grey,
                                      );
                                      }
                                    ),
                                  ),

                              

                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  onPressed:
                                      doneServiceViewModel.isDone(context)
                                      ? null : servicesWatch.length > 0
                                      ? () => doneServiceViewModel.finishService(context, scaffoldKey)
                                      : null,
                                  child: Text(
                                    'Finish',
                                    style: GoogleFonts.robotoMono(),
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

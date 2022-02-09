import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/cloud_firestore/salons_ref.dart';
import 'package:flutter_app/cloud_firestore/carousel_ref.dart';
import 'package:flutter_app/cloud_firestore/gallery_ref.dart';
import 'package:flutter_app/cloud_firestore/user_ref.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_app/model/image_model.dart';
import 'package:flutter_app/model/salon_model.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/string/strings.dart';
import 'package:flutter_app/ui/bottom_navbar.dart';
import 'package:flutter_app/ui/components/worker_widgets/salon_list.dart';
import 'package:flutter_app/ui/login_page/theme.dart';
import 'package:flutter_app/time_description/time_description.dart';
import 'package:flutter_app/view_model/worker_home/worker_home_view_model_imp.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'components/worker_widgets/appointment_list.dart';
import 'components/worker_widgets/city_list.dart';
import 'navbar.dart';

class StaffHome extends ConsumerWidget {
  final staffHomeViewModel = StaffHomeViewModelImp();

  @override
  Widget build(BuildContext context, watch) {
    var currentStaffStep = watch(staffStep).state;
    var cityWatch = watch(selectedCity).state;
    var salonWatch = watch(selectedSalon).state;
    var dateWatch = watch(selectedDate).state;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: greenColor,
        drawer: NavBar(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            title: Text(currentStaffStep == 1
                ? selectCityText
                : currentStaffStep == 2
                    ? selectSalonText
                    : currentStaffStep == 3
                        ? yourAppointmentText
                        : staffHomeText, style: yellowTextStyle.copyWith(
                fontSize: 18, fontWeight: medium)),
            centerTitle: true,
            backgroundColor: greenColor,
            iconTheme: IconThemeData(color: yellowColor),
            actions: [
              currentStaffStep == 3
                  ? InkWell(
                      child: Icon(Icons.history),
                      onTap: () =>
                          Navigator.of(context).pushNamed('/bookingHistory'),
                    )
                  : Container()
            ],
          ),
        ),
        body: Column(
          children: [
            //Area
            Expanded(
              child: currentStaffStep == 1
                  ? staffDisplayCity(staffHomeViewModel)
                  : currentStaffStep == 2
                      ? staffDisplaySalon(staffHomeViewModel, cityWatch.name)
                      : currentStaffStep == 3
                          ? displayAppointment(staffHomeViewModel, context)
                          : Container(),
              flex: 10,
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
                        onPressed: currentStaffStep == 1
                            ? null
                            : () => context.read(staffStep).state--,
                        child: Text(previousText, style:
                        greenTextStyle.copyWith(fontSize: 15, fontWeight: regular),),
                      )),
                      SizedBox(width: 30),
                      Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: yellowColor,
                            ),
                        onPressed: (currentStaffStep == 1 &&
                                    context
                                            .read(selectedCity)
                                            .state
                                            .name
                                            .length ==
                                        0) ||
                                (currentStaffStep == 2 &&
                                    context
                                            .read(selectedSalon)
                                            .state
                                            .docId!
                                            .length ==
                                        0) ||
                                currentStaffStep == 3
                            ? null
                            : () => context.read(staffStep).state++,
                        child: Text(nextText, style:
                        greenTextStyle.copyWith(fontSize: 15, fontWeight: regular),),
                      )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/string/strings.dart';
import 'package:flutter_app/ui/login_page/theme.dart';
import 'package:flutter_app/time_description/time_description.dart';
import 'package:flutter_app/view_model/worker_home/worker_home_view_model.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

displayAppointment(
    StaffHomeViewModel staffHomeViewModel, BuildContext context) {
  return FutureBuilder(
      future: staffHomeViewModel.isStaffOfThisSalon(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var result = snapshot.data as bool;
          if (result)
            return displaySlot(staffHomeViewModel, context);
          else
            return Center(
              child: Text('Sorry! You\'re not a staff of this salon!', style:
                  yellowTextStyle.copyWith(
                  fontSize: 16, fontWeight: medium)),
            );
        }
      });
}

displaySlot(StaffHomeViewModel staffHomeViewModel, BuildContext context) {
  var now = context.read(selectedDate).state;
  return Column(
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
                          '${DateFormat.MMMM().format(now)}',
                          style:
                          yellowTextStyle.copyWith(
                              fontSize: 16, fontWeight: medium),
                        ),
                        Text(
                          '${now.day}',
                          style:
                          yellowTextStyle.copyWith(
                              fontSize: 20, fontWeight: medium),
                        ),
                        Text(
                          '${DateFormat.EEEE().format(now)}',
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
                      minTime: DateTime.now(),
                      maxTime: now.add(Duration(days: 31)),
                      onConfirm: (date) =>
                          context.read(selectedDate).state = date);
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
      Expanded(
        child: FutureBuilder(
            future: staffHomeViewModel
                .displayMaxAvailableTimeSlot(context.read(selectedDate).state),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                var maxTimeSlot = snapshot.data as int;
                return FutureBuilder(
                  future: staffHomeViewModel.displayBookingSlotOfWorker(
                    context,
                    DateFormat('dd_MM_yyyy')
                        .format(context.read(selectedDate).state),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else {
                      var listTimeSlot = snapshot.data as List<int>;
                      return GridView.builder(
                          key: PageStorageKey('keep'),
                          itemCount: TIME_SLOT.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: !listTimeSlot.contains(index)
                                    ? null
                                    : () => staffHomeViewModel
                                        .processDoneServices(context, index),
                                child: Card(
                                  color: staffHomeViewModel.getColorOfThisSlot(
                                      context,
                                      listTimeSlot,
                                      index,
                                      maxTimeSlot),
                                  child: GridTile(
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('${TIME_SLOT.elementAt(index)}', style: yellowTextStyle.copyWith(
                                    fontSize: 14, fontWeight: medium)),
                                          Text(listTimeSlot.contains(index)
                                              ? fullText
                                              : maxTimeSlot > index
                                                  ? notAvailableText
                                                  : availableText, style: yellowTextStyle.copyWith(
                                              fontSize: 12, fontWeight: medium),),
                                        ],
                                      ),
                                    ),
                                    header: context.read(selectedTime).state ==
                                            TIME_SLOT.elementAt(index)
                                        ? Icon(Icons.star, color: yellowColor,)
                                        : null,
                                  ),
                                ),
                              ));
                    }
                  },
                );
              }
            }),
      )
    ],
  );
}

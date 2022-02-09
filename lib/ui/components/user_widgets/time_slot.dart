import 'package:flutter/material.dart';
import 'package:flutter_app/model/worker_model.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/ui/login_page/theme.dart';
import 'package:flutter_app/time_description/time_description.dart';
import 'package:flutter_app/view_model/booking/booking_view_model.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

displayTimeSlot(BookingViewModel bookingViewModel, BuildContext context, WorkerModel workerModel) {
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
                          style: yellowTextStyle.copyWith(
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
                  padding: const EdgeInsets.all(10),
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
            future: bookingViewModel.displayMaxAvailableTimeSlot(context.read(selectedDate).state),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                var maxTimeSlot = snapshot.data as int;
                return FutureBuilder(
                  future: bookingViewModel.displayTimeSlotOfWorker(
                    workerModel,
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
                            onTap: bookingViewModel.isAvailableForTapTimeSlot(maxTimeSlot, index, listTimeSlot)
                                ? null
                                : () {
                              bookingViewModel.onSelectedTimeSlot(context, index);
                            },
                            child: Card(
                              color: bookingViewModel.displayColorTimeSlot(context, listTimeSlot, index, maxTimeSlot),
                              child: GridTile(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          '${TIME_SLOT.elementAt(index)}', style: yellowTextStyle.copyWith(
                                          fontSize: 14, fontWeight: medium)),
                                      Text(listTimeSlot.contains(index)
                                          ? 'Full'
                                          : maxTimeSlot > index
                                          ? 'Not Available'
                                          : 'Available', style: yellowTextStyle.copyWith(
                                          fontSize: 12, fontWeight: medium))
                                    ],
                                  ),
                                ),
                                header:
                                context.read(selectedTime).state ==
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
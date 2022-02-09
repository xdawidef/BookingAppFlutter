import 'package:flutter/material.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/string/strings.dart';
import 'package:flutter_app/ui/login_page/theme.dart';
import 'package:flutter_app/view_model/booking/booking_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

displayConfirm(BookingViewModel bookingViewModel, BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Image.asset('assets/images/dashboard.png'),
        ),
      ),
      Expanded(
        flex: 3,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: lessDarkGreenColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    thankServiceText.toUpperCase(),
                    style: yellowTextStyle.copyWith(
                        fontSize: 15, fontWeight: medium),
                  ),
                  Text(
                    bookingInformationText.toUpperCase(),
                    style: yellowTextStyle.copyWith(
                        fontSize: 13, fontWeight: medium),
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: yellowColor,),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${context.read(selectedTime).state} - ${DateFormat('dd/MM/yyyy').format(context.read(selectedDate).state)}'
                            .toUpperCase(),
                        style: yellowTextStyle.copyWith(
                            fontSize: 12, fontWeight: medium),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(Icons.person, color: yellowColor,),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${context.read(selectedWorker).state.name}'
                            .toUpperCase(),
                        style: yellowTextStyle.copyWith(
                            fontSize: 12, fontWeight: medium),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                  Row(
                    children: [
                      Icon(Icons.home, color: yellowColor,),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${context.read(selectedSalon).state.name}'
                            .toUpperCase(),
                        style: yellowTextStyle.copyWith(
                            fontSize: 12, fontWeight: medium),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: yellowColor,),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${context.read(selectedSalon).state.address}'
                            .toUpperCase(),
                        style: yellowTextStyle.copyWith(
                            fontSize: 12, fontWeight: medium),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () => bookingViewModel.confirmBooking(context, scaffoldKey),
                    child: Text('Confirm', style: yellowTextStyle.copyWith(
                        fontSize: 15, fontWeight: medium)),
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(darkGreenColor)),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    ],
  );
}
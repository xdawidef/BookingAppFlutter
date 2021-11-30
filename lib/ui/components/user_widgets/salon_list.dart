
import 'package:flutter/material.dart';
import 'package:flutter_app/model/salon_model.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/ui/login_page/theme.dart';
import 'package:flutter_app/view_model/booking/booking_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

displaySalon(BookingViewModel bookingViewModel, String cityName) {
  return FutureBuilder(
      future: bookingViewModel.displaySalonByCity(cityName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var salons = snapshot.data as List<SalonModel>;
          if (salons.length == 0)
            return Center(
              child: Text('Cannot load list with Salons'),
            );
          else {
            return ListView.builder(
                key: PageStorageKey('keep'),
                itemCount: salons.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () =>
                    context.read(selectedSalon).state = salons[index],
                    child: Card(
                      child: ListTile(
                        tileColor: bookingViewModel.isSalonSelected(context, salons[index])
                            ? lessDarkGreenColor
                            : darkGreenColor,
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: CircleAvatar(
                            backgroundImage:  NetworkImage(salons[index].salonLogo),
                          ),
                        ),
                        trailing: context.read(selectedSalon).state.docId ==
                            salons[index].docId
                            ? Icon(Icons.home_outlined, color: yellowColor)
                            : Icon(Icons.home_outlined, color: Colors.black),
                        title: Text(
                          '${salons[index].name}',
                          style: yellowTextStyle.copyWith(
                              fontSize: 18, fontWeight: medium),
                        ),
                        subtitle: Text(
                          '${salons[index].address}',
                          style: GoogleFonts.saira(
                              fontStyle: FontStyle.italic, color: yellowColor,),
                        ),
                      ),
                    ),
                  );
                });
          }
        }
      });
}
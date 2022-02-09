import 'package:flutter/material.dart';
import 'package:flutter_app/model/salon_model.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/string/strings.dart';
import 'package:flutter_app/ui/login_page/theme.dart';
import 'package:flutter_app/view_model/worker_home/worker_home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

staffDisplaySalon(StaffHomeViewModel staffHomeViewModel, String name) {
  return FutureBuilder(
      future: staffHomeViewModel.displaySalonByCity(name),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var salons = snapshot.data as List<SalonModel>;
          if (salons.length == 0)
            return Center(
              child: Text(cannotLoadSalonList),
            );
          else {
            return ListView.builder(
                itemCount: salons.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => staffHomeViewModel.onSelectedSalon(context, salons[index]),
                    child: Card(
                      child: ListTile(
                        tileColor: staffHomeViewModel.isSalonSelected(context, salons[index])
                            ? lessDarkGreenColor
                            : darkGreenColor,
                        shape: staffHomeViewModel.isSalonSelected(context, salons[index])
                            ? RoundedRectangleBorder(
                            side:
                            BorderSide(color: yellowColor, width: 3),
                            borderRadius: BorderRadius.circular(5))
                            : null,
                        leading:
                        Icon(Icons.home_outlined, color: yellowColor),
                        trailing: context.read(selectedSalon).state.docId ==
                            salons[index].docId
                            ? Icon(Icons.home_outlined, color: yellowColor,)
                            : Icon(Icons.home_outlined, color: Colors.black),
                        title: Text(
                          '${salons[index].name}',
                          style: yellowTextStyle.copyWith(
                              fontSize: 18, fontWeight: medium),
                        ),
                        subtitle: Text(
                          '${salons[index].address}',
                            style: GoogleFonts.saira(
                              fontStyle: FontStyle.italic, color: yellowColor,)
                        ),
                      ),
                    ),
                  );
                });
          }
        }
      });
}
import 'package:flutter/material.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/string/strings.dart';
import 'package:flutter_app/ui/login_page/theme.dart';
import 'package:flutter_app/view_model/worker_home/worker_home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

staffDisplayCity(StaffHomeViewModel staffHomeViewModel) {
  return FutureBuilder(
      future: staffHomeViewModel.displayCities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var cities = snapshot.data as List<CityModel>;
          if (cities.length == 0)
            return Center(
              child: Text(cannotLoadCityText),
            );
          else {
            return GridView.builder(
                itemCount: cities.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () =>
                    staffHomeViewModel.onSelectedCity(context, cities[index]),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        shape: staffHomeViewModel.isCitySelected(context, cities[index])
                            ? RoundedRectangleBorder(
                            side:
                            BorderSide(color: yellowColor, width: 3),
                            borderRadius: BorderRadius.circular(5))
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(cities[index].cityPhoto),
                            ),
                          ),
                          child: Center(
                            child: Container(
                              child: Text('${cities[index].name}', style: yellowTextStyle.copyWith(
                                  fontSize: 18, fontWeight: medium), textAlign: TextAlign.center),
                              decoration: BoxDecoration(
                                color: darkGreenColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        }
      });
}
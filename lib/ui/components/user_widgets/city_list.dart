import 'package:flutter/material.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_app/string/strings.dart';
import 'package:flutter_app/ui/login_page/theme.dart';
import 'package:flutter_app/view_model/booking/booking_view_model.dart';

displayCityList(BookingViewModel bookingViewModel) {
  return FutureBuilder(
      future: bookingViewModel.displayCities(),
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
            return ListView.builder(
                key: PageStorageKey('keep'),
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => bookingViewModel.onSelectedCity(context, cities[index]),
                    child: Card(
                      child: ListTile(
                        tileColor: bookingViewModel.isCitySelected(context, cities[index])
                            ? lessDarkGreenColor
                            : darkGreenColor,
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(cities[index].cityPhoto),
                          ),
                        ),
                        trailing: bookingViewModel.isCitySelected(context, cities[index])
                            ? Icon(Icons.location_city, color: yellowColor,)
                            : Icon(Icons.location_city),
                        title: Text(
                          '${cities[index].name}',
                          style: yellowTextStyle.copyWith(
                              fontSize: 18, fontWeight: medium),
                        ),
                      ),
                    ),
                  );
                });
          }
        }
      });
}
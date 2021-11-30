import 'package:flutter/material.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_app/model/salon_model.dart';

abstract class StaffHomeViewModel{
  //City
  Future<List<CityModel>> displayCities();
  void onSelectedCity(BuildContext context, CityModel cityModel);
  bool isCitySelected(BuildContext context, CityModel cityModel);

  //Salon
  Future<List<SalonModel>> displaySalonByCity(String cityName);
  void onSelectedSalon(BuildContext context, SalonModel salonModel);
  bool isSalonSelected(BuildContext context, SalonModel salonModel);

  //Apointment
  Future<bool> isStaffOfThisSalon(BuildContext context);
  Future<int> displayMaxAvailableTimeSlot(DateTime dt);
  Future<List<int>> displayBookingSlotOfWorker(BuildContext context, String date);
  bool isTimeSlotBooked(List<int> listTimeSlot, int index);
  void processDoneServices(BuildContext context, int index);
  Color getColorOfThisSlot(BuildContext context, List<int> listTimeSlot, int index, int maxTimeSlot);

}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_app/model/salon_model.dart';
import 'package:flutter_app/model/worker_model.dart';

abstract class BookingViewModel{
  //City
  Future<List<CityModel>> displayCities();
  void onSelectedCity(BuildContext context, CityModel cityModel);
  bool isCitySelected(BuildContext context, CityModel cityModel);

  //Salon
  Future<List<SalonModel>> displaySalonByCity(String cityName);
  void onSelectedSalon(BuildContext context, SalonModel salonModel);
  bool isSalonSelected(BuildContext context, SalonModel salonModel);

  //Worker
  Future<List<WorkerModel>> displayWorkersBySalon(SalonModel salonModel);
  void onSelectedWorker(BuildContext context, WorkerModel workerModel);
  bool isWorkerSelected(BuildContext context, WorkerModel workerModel);

  //Timeslot
  Future<int> displayMaxAvailableTimeSlot(DateTime dt);
  Future<List<int>> displayTimeSlotOfWorker(WorkerModel workerModel, String date);
  bool isAvailableForTapTimeSlot(int maxTime,
      int index,
      List<int> listTimeSlot);
  void onSelectedTimeSlot(BuildContext context, int index);
  Color displayColorTimeSlot(BuildContext context,
      List<int> listTimeSlot,
      int index,
      int maxTimeSlot);

  void confirmBooking(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey);
}
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/booking_model.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_app/model/salon_model.dart';
import 'package:flutter_app/model/worker_model.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

Future<BookingModel> getDetailBooking(BuildContext context, int timeSlot) async{
  CollectionReference userRef = FirebaseFirestore.instance
      .collection('Salons')
      .doc(context.read(selectedCity).state.name)
      .collection('Field')
      .doc(context.read(selectedSalon).state.docId)
      .collection('Worker')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(DateFormat('dd_MM_yyyy').format(context.read(selectedDate).state));
  DocumentSnapshot snapshot = await userRef.doc(timeSlot.toString()).get();
  if(snapshot.exists)
    {
      var bookingModel = BookingModel.fromJson(json.decode(json.encode(snapshot.data())));
      bookingModel.docId = snapshot.id;
      bookingModel.reference = snapshot.reference;
      context.read(selectedBooking).state = bookingModel;
      return bookingModel;
    } else{
    return BookingModel(
        totalPrice: 0,
        timeStamp: 0,
        salonId: '',
        done: false,
        salonName: '',
        salonAddress: '',
        workerId: '',
        slot: 0,
        workerName: '',
        cityBook: '',
        customerPhone: '',
        customerId: '', time: '', customerName: '');
  }
}

Future<List<WorkerModel>> getWorkerBySalon(SalonModel salon) async {
  var workers = new List<WorkerModel>.empty(growable: true);
  var workerRef = salon.reference!.collection('Worker');
  var snapshot = await workerRef.get();
  snapshot.docs.forEach((element) {
    var worker = WorkerModel.fromJson(element.data());
    worker.docId = element.id;
    worker.reference = element.reference;
    workers.add(worker);
  });
  return workers;
}

Future<List<CityModel>> getCities() async {
  var cities = new List<CityModel>.empty(growable: true);
  var cityRef = FirebaseFirestore.instance.collection('Salons');
  var snapshot = await cityRef.get();
  snapshot.docs.forEach((element) {
    cities.add(CityModel.fromJson(element.data()));
  });
  return cities;
}

Future<List<SalonModel>> getSalonByCity(String cityName) async {
  var salons = new List<SalonModel>.empty(growable: true);
  var salonRef = FirebaseFirestore.instance
      .collection('Salons')
      .doc(cityName.replaceAll(' ', ''))
      .collection('Field');
  var snapshot = await salonRef.get();
  snapshot.docs.forEach((element) {
    var salon = SalonModel.fromJson(element.data());
    salon.docId = element.id;
    salon.reference = element.reference;
    salons.add(salon);
  });
  return salons;
}

Future<List<int>> getTimeSlotOfWorker(WorkerModel workerModel, String date) async {
  List<int> result = new List<int>.empty(growable: true);
  var bookingRef = workerModel.reference!.collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  snapshot.docs.forEach((element) {
    result.add(int.parse(element.id));
  });
  return result;
}

Future<bool> checkStaffOfThisSalon(BuildContext context) async {
  DocumentSnapshot workerSnapshot = await FirebaseFirestore.instance
      .collection('Salons')
      .doc('${context.read(selectedCity).state.name}')
      .collection('Field')
      .doc('${context.read(selectedSalon).state.docId}')
      .collection('Worker')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
  return workerSnapshot.exists;
}

Future<List<int>> getBookingSlotOfWorker(BuildContext context, String date) async {
  var workerDocument = FirebaseFirestore.instance
      .collection('Salons')
      .doc('${context.read(selectedCity).state.name}')
      .collection('Field')
      .doc('${context.read(selectedSalon).state.docId}')
      .collection('Worker')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  List<int> result = new List<int>.empty(growable: true);
  var bookingRef = workerDocument.collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  snapshot.docs.forEach((element) {
    result.add(int.parse(element.id));
  });
  return result;
}

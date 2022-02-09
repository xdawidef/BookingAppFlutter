import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/model/booking_model.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_app/model/salon_model.dart';
import 'package:flutter_app/model/service_model.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/model/worker_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userLogged = StateProvider((ref) => FirebaseAuth.instance.currentUser);
final userToken = StateProvider((ref) => '');
final forceReload = StateProvider((ref) => false);
final userInformation = StateProvider((ref) => UserModel(name: '', address: '', profileImage: ''));
final currentStep = StateProvider((ref) => 1);
final selectedCity = StateProvider((ref) => CityModel(name: ''));
final selectedSalon = StateProvider((ref) => SalonModel(address: '', name: ''));
final selectedWorker = StateProvider((ref) => WorkerModel());
final selectedDate = StateProvider((ref) => DateTime.now());
final selectedTimeSlot = StateProvider((ref) => -1);
final selectedTime = StateProvider((ref) => '');
final deleteBooking = StateProvider((ref) => false);
final staffStep = StateProvider((ref) => 1);
final selectedBooking = StateProvider((ref) => BookingModel(
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
    customerId: '', time: '', customerName: ''));
final selectedServices = StateProvider((ref) => List<ServiceModel>.empty(growable: true));
final isLoading = StateProvider((ref)=>false);
final workerHistorySelectedDate = StateProvider((ref) => DateTime.now());
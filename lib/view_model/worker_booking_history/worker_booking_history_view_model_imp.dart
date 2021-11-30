import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/cloud_firestore/user_ref.dart';
import 'package:flutter_app/model/booking_model.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/view_model/worker_booking_history/worker_booking_history_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WorkerBookingHistoryViewModelImp implements WorkerBookingHistoryViewModel {
  @override
  Future<List<BookingModel>> getWorkerBookingHistory(BuildContext context, DateTime dateTime) async {
    
    var listBooking = List<BookingModel>.empty(growable: true);
    var workerDocument = FirebaseFirestore.instance
    .collection('AllSalon')
    .doc('${context.read(selectedCity).state.name}')
    .collection('Spa')
    .doc('${context.read(selectedSalon).state.docId}')
    .collection('Worker')
    .doc('${FirebaseAuth.instance.currentUser!.uid}')
    .collection(DateFormat('dd_MM_yyyy').format(dateTime));
    var snapshot = await workerDocument.get();
    snapshot.docs.forEach((element) {
      var workerBooking = BookingModel.fromJson(element.data());
      workerBooking.docId = element.id;
      workerBooking.reference = element.reference;
      listBooking.add(workerBooking);
    });
    return listBooking;
  }

}
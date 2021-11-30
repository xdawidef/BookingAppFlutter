import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/cloud_firestore/user_ref.dart';
import 'package:flutter_app/model/booking_model.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/view_model/user_history/user_history_view_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserHistoryViewModelImp implements UserHistoryViewModel{
  @override
  Future<List<BookingModel>> displayUserHistory() {
    return getUserHistory();
  }

  @override
  void userCancelBooking(BuildContext context, BookingModel bookingModel) {
    var batch = FirebaseFirestore.instance.batch();
    var workerBooking = FirebaseFirestore.instance
        .collection('AllSalon')
        .doc(bookingModel.cityBook)
        .collection('Spa')
        .doc(bookingModel.salonId)
        .collection('Worker')
        .doc(bookingModel.workerId)
        .collection(DateFormat('dd_MM_yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp)))
        .doc(bookingModel.slot.toString());
    var userBooking = bookingModel.reference;

    //Delete
    batch.delete(userBooking!);
    batch.delete(workerBooking);

    batch.commit().then((value) {
      //Refresh data
      context.read(deleteFlagRefresh).state =
      !context.read(deleteFlagRefresh).state;
    });
  }

}
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/booking_model.dart';

abstract class WorkerBookingHistoryViewModel {
  Future<List<BookingModel>> getWorkerBookingHistory(
      BuildContext context, DateTime dateTime
      );

}
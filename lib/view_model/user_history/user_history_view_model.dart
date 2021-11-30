import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/booking_model.dart';

abstract class UserHistoryViewModel {
  Future<List<BookingModel>> displayUserHistory();

  void userCancelBooking(BuildContext context, BookingModel bookingModel);
  
}

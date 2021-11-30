import 'package:flutter_app/model/service_model.dart';
import 'package:ntp/ntp.dart';

enum LOGIN_STATE { LOGGED, NOT_LOGIN }

const TIME_SLOT = {
  '10:00 - 10:30',
  '10:30 - 11:00',
  '11:00 - 11:30',
  '11:30 - 12:00',
  '12:00 - 12:30',
  '12:30 - 13:00',
  '13:00 - 13:30',
  '13:30 - 14:00',
  '14:00 - 14:30',
  '14:30 - 15:00',
  '15:00 - 15:30',
  '15:30 - 16:00',
  '16:00 - 16:30',
  '16:30 - 17:00',
  '17:00 - 17:30',
  '17:30 - 18:00',
  '18:00 - 18:30',
  '18:30 - 19:00',
};

Future<int> getMaxAvailableTimeSlot(DateTime dt) async {
  DateTime now = dt.toLocal();
  int offset =
      await NTP.getNtpOffset(localTime: now); // Synchro with time server
  DateTime syncTime = now.add(Duration(milliseconds: offset));
  //Compare with local time to enable slot
  if (syncTime.isBefore(DateTime(now.year, now.month, now.day, 10, 0)))
    return 0;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 10, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 10, 30)))
    return 1; // return next available slot
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 10, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 11, 0)))
    return 2;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 11, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 11, 30)))
    return 3;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 11, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 12, 0)))
    return 4;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 12, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 12, 30)))
    return 5;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 12, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 13, 0)))
    return 6;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 13, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 13, 30)))
    return 7;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 13, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 14, 0)))
    return 8;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 14, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 14, 30)))
    return 9;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 14, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 15, 0)))
    return 10;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 15, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 15, 30)))
    return 11;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 15, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 16, 0)))
    return 12;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 16, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 16, 30)))
    return 13;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 16, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 17, 0)))
    return 14;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 17, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 17, 30)))
    return 15;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 17, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 18, 0)))
    return 16;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 18, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 18, 30)))
    return 17;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 18, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 19, 0)))
    return 18;
  else return 21;

}

Future<DateTime> syncTime() async{
  var now = DateTime.now();
  var offset = await NTP.getNtpOffset(localTime: now);
  return now.add(Duration(milliseconds: offset));
}

String convertServices(List<ServiceModel> services){
  String result = '';
  if(services != null && services.length > 0)
    {
      services.forEach((element) {
        result += '${element.name}';
      });
    }
  return result.substring(0,result.length-2);
}
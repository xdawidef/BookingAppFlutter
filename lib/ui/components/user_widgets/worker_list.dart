import 'package:flutter/material.dart';
import 'package:flutter_app/model/salon_model.dart';
import 'package:flutter_app/model/worker_model.dart';
import 'package:flutter_app/string/strings.dart';
import 'package:flutter_app/ui/login_page/theme.dart';
import 'package:flutter_app/view_model/booking/booking_view_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

displayWorker(BookingViewModel bookingViewModel, SalonModel salonModel) {
  return FutureBuilder(
      future: bookingViewModel.displayWorkersBySalon(salonModel),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var workers = snapshot.data as List<WorkerModel>;
          if (workers.length == 0)
            return Center(
              child: Text(workerEmptyText),
            );
          else {
            return ListView.builder(
                key: PageStorageKey('keep'),
                itemCount: workers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => bookingViewModel.onSelectedWorker(context, workers[index]),
                    child: Card(
                      child: ListTile(
                        tileColor: bookingViewModel.isWorkerSelected(context, workers[index])
                            ? lessDarkGreenColor
                            : darkGreenColor,
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: CircleAvatar(
                            backgroundImage:  NetworkImage(workers[index].workerPhoto),
                          ),
                        ),
                        trailing: bookingViewModel.isWorkerSelected(context, workers[index])
                            ? Icon(Icons.person, color: yellowColor,)
                            : Icon(Icons.person,),
                        title: Text(
                          '${workers[index].name}',
                          style: yellowTextStyle.copyWith(
                              fontSize: 18, fontWeight: medium),
                        ),
                        subtitle: RatingBar.builder(
                          itemSize: 16,
                          allowHalfRating: true,
                          initialRating: workers[index].rating,
                          ignoreGestures: true,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, _) =>
                              Icon(Icons.star, color: Colors.amber),
                          itemPadding: const EdgeInsets.all(4),
                          onRatingUpdate: (va){},
                        ),
                      ),
                    ),
                  );
                });
          }
        }
      });
}
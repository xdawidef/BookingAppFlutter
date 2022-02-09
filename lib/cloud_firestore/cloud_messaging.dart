import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getServerKey() async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('CloudMessaging')
      .doc('serverKey')
      .get();
  if (snapshot.exists) {
    var key = (snapshot.data() as Map)['key'];
    return key;
  } else {
    return 'EMPTY';
  }
}

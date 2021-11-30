import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/model/image_model.dart';
import 'package:flutter_app/model/user_model.dart';

Future<List<ImageModel>> getLookbook() async {
  List<ImageModel> result = new List<ImageModel>.empty(growable: true);
  CollectionReference bannerRef = FirebaseFirestore.instance.collection('Lookbook');
  QuerySnapshot snapshot = await bannerRef.get();
  snapshot.docs.forEach((element) {
    final data = element.data() as Map<String, dynamic>;
    result.add(ImageModel.fromJson(data));
  });
  return result;
}

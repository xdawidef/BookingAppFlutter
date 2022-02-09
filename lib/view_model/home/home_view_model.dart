import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/image_model.dart';
import 'package:flutter_app/model/user_model.dart';

abstract class HomeViewModel{
  Future<UserModel> displayUserProfile(BuildContext context, String phoneNumber);
  Future<List<ImageModel>> displayCarousel();
  Future<List<ImageModel>> displayGallery();

  bool isStaff(BuildContext context);


}
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/cloud_firestore/banner_ref.dart';
import 'package:flutter_app/cloud_firestore/lookbook_ref.dart';
import 'package:flutter_app/cloud_firestore/user_ref.dart';
import 'package:flutter_app/model/image_model.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/state/state_management.dart';
import 'package:flutter_app/view_model/home/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewModelImp implements HomeViewModel{
  @override
  Future<List<ImageModel>> displayBanner() {
    return getBanners();
  }

  @override
  Future<List<ImageModel>> displayLookbook() {
    return getLookbook();
  }

  @override
  Future<UserModel> displayUserProfile(BuildContext context, String phoneNumber) {
    return getUserProfiles(context, phoneNumber);
  }

  @override
  bool isStaff(BuildContext context) {
    return context
        .read(userInformation)
        .state
        .isStaff;
  }
  
}
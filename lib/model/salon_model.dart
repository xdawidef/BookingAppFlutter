import 'package:cloud_firestore/cloud_firestore.dart';

class SalonModel{
  String name='', address='', salonLogo='';
  String? docId='';
  DocumentReference? reference;

  SalonModel({required this.name, required this.address});

  SalonModel.fromJson(Map<String, dynamic> json){
    address = json['address'];
    name = json['name'];
    salonLogo = json['salonLogo'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['name'] = this.name;
    data['salonLogo'] = this.salonLogo;
    return data;
  }
}
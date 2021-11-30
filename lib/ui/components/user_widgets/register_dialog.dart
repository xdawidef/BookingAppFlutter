import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void showRegisterDialog(BuildContext context, CollectionReference userRef, GlobalKey<ScaffoldState> scaffoldState)
{
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  Alert(
      context: context,
      title: 'Update profiles',
      content: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Name'),
            controller: nameController,
          ),
          TextField(
            decoration: InputDecoration(
                icon: Icon(Icons.home), labelText: 'Address'),
            controller: addressController,
          )
        ],
      ),
      buttons: [
        DialogButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context)),
        DialogButton(
            child: Text('Update'),
            onPressed: () {
              userRef
                  .doc(FirebaseAuth
                  .instance.currentUser!.phoneNumber)
                  .set({
                'name': nameController.text,
                'address': addressController.text,
                'profileImage' : '',
              }).then((value) async {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                    scaffoldState.currentContext!)
                    .showSnackBar(SnackBar(
                    content:
                    Text('Update profile success')));
                await Future.delayed(Duration(seconds: 1),
                        () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/intro', (route) => false);
                    });
              }).catchError((e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                    scaffoldState.currentContext!)
                    .showSnackBar(
                    SnackBar(content: Text('$e')));
              });
            }),
      ]).show();
}
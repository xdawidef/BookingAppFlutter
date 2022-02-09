import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/ui/login_page/theme.dart';
import 'package:flutter_app/view_model/home/home_view_model_imp.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileBody extends StatefulWidget {
  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  File file = File('');
  final homeViewModel = HomeViewModelImp();
  var locationController = TextEditingController();
  var nameController = TextEditingController();
  var addressController = TextEditingController();

  Position? position;
  List<Placemark>? placeMarks;

  getCurrentLocation() async{
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true
    );
    position = newPosition;
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];

    String completeAddress = '${pMark.thoroughfare} ${pMark.subThoroughfare}, ${pMark.postalCode} ${pMark.locality}, ${pMark.administrativeArea}, ${pMark.country}';
    locationController.text = completeAddress;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenColor,
      body: SingleChildScrollView (
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 240,
              child: Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: CustomShape(),
                    child: Container(
                      height: 150,
                      color: yellowColor,
                    ),
                  ),
                  FutureBuilder(
                      future: homeViewModel.displayUserProfile(context, FirebaseAuth.instance.currentUser!.phoneNumber!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(
                          child: CircularProgressIndicator(),
                          );
                        else
                          {
                            var userModel = snapshot.data as UserModel;
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    child: SizedBox(
                                      height: 140,
                                      width: 140,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        overflow: Overflow.visible,
                                        children: [
                                           CircleAvatar(
                                            backgroundImage: NetworkImage('${userModel.profileImage}'),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: -12,
                                            child: SizedBox(
                                              height: 46,
                                              width: 46,
                                              child: FlatButton(
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50),
                                                  side: BorderSide(color: greenColor),
                                                ),
                                                color: Color(0xFFF5F6F9),
                                                onPressed: () {
                                                  chooseImage(context);
                                                },
                                                child: SvgPicture.asset(
                                                    'assets/icons/camera.svg'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text('${userModel.name}',
                                      style: yellowTextStyle.copyWith(
                                          fontSize: 18, fontWeight: medium)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('${userModel.address}',
                                      style: redTextStyle.copyWith(
                                          fontSize: 15, fontWeight: regular)),

                                ],
                              ),
                            );
                          }
                  }),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: TextField(
                    style: TextStyle(color: yellowColor,),
                    decoration: InputDecoration(
                      labelText: 'Change your name:',
                      labelStyle: TextStyle(color: yellowColor,),
                      prefixIcon: Icon(Icons.person, color: yellowColor,),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: yellowColor, width: 1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: yellowColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: yellowColor, width: 1),
                      ),
                    ),
                    controller: nameController,
                    enabled: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: TextField(
                    style: TextStyle(color: yellowColor,),
                    decoration: InputDecoration(
                      labelText: 'Change your address:',
                      labelStyle: TextStyle(color: yellowColor,),
                      prefixIcon: Icon(Icons.mail, color: yellowColor,),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: yellowColor, width: 1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: yellowColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: yellowColor, width: 1),
                      ),
                    ),
                    controller: addressController,
                    enabled: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: TextField(
                    style: TextStyle(color: yellowColor,),
                    decoration: InputDecoration(
                      labelText: 'My current location:',
                      labelStyle: TextStyle(color: yellowColor,),
                      prefixIcon: Icon(Icons.my_location, color: yellowColor,),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: yellowColor, width: 1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: yellowColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: yellowColor, width: 1),
                      ),
                    ),
                      controller: locationController,
                      readOnly: true,
                  ),
                ),
                Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    label: Text('Get my current location', style: greenTextStyle.copyWith(fontSize: 14, fontWeight: medium)),
                    icon: Icon(Icons.location_on, color: greenColor,),
                    onPressed: () {
                      getCurrentLocation();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: yellowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),


                 //Guzik do update
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: yellowColor,
              ),
              onPressed: (){
                updateProfile(context);
              },
              child: Text('Update', style:
              greenTextStyle.copyWith(fontSize: 15, fontWeight: regular),),
            ),
          ],
        ),
      ),
    );
  }

  updateProfile(BuildContext context) async{
    CollectionReference userRef =
    FirebaseFirestore.instance.collection('User');

    userRef.doc(FirebaseAuth.instance.currentUser!.phoneNumber).update({
      'name': nameController.text,
      'address': addressController.text,
    });
    setState(() {

    });
  }

  chooseImage(BuildContext context)  async{

    XFile? xfile =  await ImagePicker().pickImage(source: ImageSource.gallery);
    print('file ' + xfile!.path);
    file = File(xfile.path);

    Map<String, dynamic> map = Map();
    if (file != null){
      String url = await uploadImage();
      map['profileImage'] = url;
    }
    await FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser!.phoneNumber!).update(map);
    setState(() {

    });
  }
 Future<String> uploadImage() async{
    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .ref()
        .child('profile')
        .child(FirebaseAuth.instance.currentUser!.uid + '_' + basename(file.path)).putFile(file);
   file = File('');

    return taskSnapshot.ref.getDownloadURL();
  }

}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

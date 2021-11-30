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
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileBody extends StatefulWidget {
  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  File file = File('');
  final homeViewModel = HomeViewModelImp();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenColor,
      body: Column(
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
                                 // height: 140,
                               //   width: 140,
                                  // decoration: BoxDecoration(
                                  //   shape: BoxShape.circle,
                                  //     border: Border.all(color: greenColor, width: 8),
                                  //     image: DecorationImage(
                                  //       fit: BoxFit.cover,
                                  //   image: NetworkImage(
                                  //       'https://i1.sndcdn.com/artworks-000571067396-kjsbx8-t500x500.jpg'),
                                  // )),
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
                                Text('Staff Tomasz',
                                    style: yellowTextStyle.copyWith(
                                        fontSize: 18, fontWeight: medium)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('stafftomasz@gmail.com',
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

               //Guzik do update
          // SizedBox(
          //   height: 5,
          // ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     primary: yellowColor,
          //   ),
          //   onPressed: (){
          //    // updateProfile(context);
          //   },
          //   child: Text('Update', style:
          //   greenTextStyle.copyWith(fontSize: 15, fontWeight: regular),),
          // ),
        ],
      ),
    );
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

  // updateProfile(BuildContext context) async{
  //   Map<String, dynamic> map = Map();
  //   if (file != null){
  //     String url = await uploadImage();
  //     map['profileImage'] = url;
  //   }
  //   await FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser!.phoneNumber!).update(map);
  //   setState(() {
  //
  //   });
  // }

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

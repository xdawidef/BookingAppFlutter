import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/view_model/home/home_view_model_imp.dart';
import 'package:flutter_app/view_model/main/main_view_model_imp.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatelessWidget {
  final homeViewModel = HomeViewModelImp();
  final mainViewModel = MainViewModelImp();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder(
              future: homeViewModel.displayUserProfile(context,
                  FirebaseAuth.instance.currentUser!.phoneNumber!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  var userModel = snapshot.data as UserModel;
                  return UserAccountsDrawerHeader(
                    accountName: Text('${userModel.name}',
                        style: GoogleFonts.robotoMono(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),),
                    accountEmail: Text('${userModel.address}',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.robotoMono(
                          color: Colors.white,),),
                    currentAccountPicture: CircleAvatar(
                      child: ClipOval(
                        child: Image.network(
                          '${userModel.profileImage}',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://ifmga.info/sites/default/files/styles/homepage_slideshow/public/homepage_slideshow/ifmga_dominik_meyer_-_kala_patar.jpg?itok=MxZMn-Eu'
                        ),
                        fit: BoxFit.cover,
                      ),

                    ),
                  );
                }

              }),
          homeViewModel.isStaff(context) ?
          ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text('Staff panel'),
            onTap: ()=> Navigator.of(context).pushNamed(
            '/staffHome'),
          ) : Container(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: ()=> Navigator.of(context).pushNamed(
                '/start'),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Friends'),
            onTap: ()=> null,
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: ()=> null,
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: ()=> null,
          ),
          Divider(
            thickness: 1.5,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: ()=> null,
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Polities'),
            onTap: ()=> null,
          ),
          Divider(
            thickness: 1.5,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: ()=> {
              mainViewModel.logout(context)
            },
          ),
        ],
      ),
    );
  }


}

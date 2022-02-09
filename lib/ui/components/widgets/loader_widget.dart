import 'package:flutter/material.dart';
import 'package:flutter_app/ui/login_page/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class LoaderWidget extends StatelessWidget{
  String text='';

  LoaderWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircularProgressIndicator(),
      SizedBox(height: 10,),
      Text(text, style: yellowTextStyle.copyWith(
          fontSize: 14, fontWeight: medium),)
    ],),);
  }

}
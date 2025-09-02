
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/authservice.dart';
import 'package:flutter_application_1/widgets/createloggedout.dart';
import 'package:flutter_application_1/widgets/createpage.dart';
import 'package:flutter_application_1/widgets/loading.dart';
class CreatorPage extends StatefulWidget {
  const CreatorPage({super.key});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}
class _CreatorPageState extends State<CreatorPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return  
    ValueListenableBuilder(
      valueListenable:authservice,builder: (context, authservice, child){
        return StreamBuilder(stream: authservice.authStateChanges , builder:(context, snapshot) {
          Widget widget;
          if(snapshot.connectionState==ConnectionState.waiting)
          {widget=LoadingPage();}
          else if(snapshot.hasData) {widget=Createpage();}
          else{widget=CreatorOut();}
          return widget;
        },);
      }
    );
   
  }
}
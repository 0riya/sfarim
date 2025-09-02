
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/accountloggedin.dart';
import 'package:flutter_application_1/widgets/acoountloggedout.dart';
import 'package:flutter_application_1/widgets/authservice.dart';
import 'package:flutter_application_1/widgets/loading.dart';
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}
class _AccountPageState extends State<AccountPage> {
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
          else if(snapshot.hasData) {widget=LoggedInPage();}
          else{widget=LoggedOutPage();}
          return widget;
        },);
      }
    );
   
  }
}
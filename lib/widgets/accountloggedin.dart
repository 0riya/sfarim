import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/authservice.dart';
class LoggedInPage extends StatelessWidget {
  const LoggedInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: 
            [ 
              TextButton(onPressed:() => Authservice().logout(),child:const Text("logout")),
            ]
          )),

      );
  }
}
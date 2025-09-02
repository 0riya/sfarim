
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/authservice.dart';
import 'package:flutter_application_1/widgets/tabbar.dart';
class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final email=TextEditingController();
  final password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  
    Scaffold(
      appBar:AppBar(),
      body:Center(
        child: Padding(
          padding: const EdgeInsets.all(500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: 
            [ 
              TextField(decoration:InputDecoration(border:OutlineInputBorder(borderRadius:BorderRadius.circular(10)),hintText:"Enter your email"),controller:email,),
              SizedBox(height:10),
              TextField(decoration:InputDecoration(border: OutlineInputBorder(borderRadius:BorderRadius.circular(10)),hintText:"Enter your password"),controller:password,),
              TextButton(onPressed:() { Authservice().login(email: email.text,password: password.text); Navigator.push(context, MaterialPageRoute(builder: (context) => const MyTab()));}, child: const Text("login")),
            ]
          ),
        ))
      );
  }
}
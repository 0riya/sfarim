import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/login.dart';
import 'package:flutter_application_1/widgets/signup.dart';
class CreatorOut extends StatelessWidget {
  const CreatorOut({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: 
            [ 
              Text("please log in to use the creator page"),
              TextButton(onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Loginpage()));},child:const Text("Login")),
              TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));}, child: const Text("sign up")),
            ]
          )),

      );
  }
}
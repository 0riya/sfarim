import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/widgets/chaptereditor.dart';
import 'package:flutter_application_1/widgets/myroute.dart';
class Chapterbutton extends StatefulWidget {
  const Chapterbutton({super.key, required this.isuser,required this.id,required this.chapterid,required this.json,required this.number,required this.imageurl,required this.desc,required this.title});
  final String id;
  final String chapterid;
  final bool isuser;
  final String json;
  final int number;
  final String title;
  final String desc;
  final String imageurl;

  @override
  State<Chapterbutton> createState() => _ChapterbuttonState();
}

class _ChapterbuttonState extends State<Chapterbutton> {
    CollectionReference novels = FirebaseFirestore.instance.collection('novels');


  @override
  Widget build(BuildContext context) {
    return Stack(children:[Ink(width: double.infinity,height:50,color:(widget.number%2==0)?Color.fromARGB(200, 194, 194, 194):Colors.white,), Padding(
              padding:  EdgeInsets.only(top:5),
              child: Row(crossAxisAlignment:CrossAxisAlignment.center,mainAxisAlignment:MainAxisAlignment.start,children:
              [
                TextButton(onPressed:() => Navigator.push(context, Myroute(builder: (context) =>Chaptereditor(id:widget.id,initchapterid:widget.chapterid,isuser:widget.isuser,json:widget.json,desc:widget.desc,title: widget.title,imageurl: widget.imageurl,))), child: Text("chapter ${widget.number}"))
              ]
              )
    )]);
  }
}
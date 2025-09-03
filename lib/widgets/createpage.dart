import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/authservice.dart';
import 'package:flutter_application_1/widgets/bookbutton.dart';
import 'package:flutter_application_1/widgets/createbook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/widgets/loading.dart';

class Createpage extends StatefulWidget {
  const Createpage({super.key});

  @override
  State<Createpage> createState() => _CreatepageState();
}

class _CreatepageState extends State<Createpage> {
  CollectionReference novels = FirebaseFirestore.instance.collection('novels');
  late List<Map<String, dynamic>> items;
  bool isloaded = false;
  getmynovels() async {
    var data = await novels
        .where('userid', isEqualTo: Authservice().currentUser!.uid)
        .get();
    var templist = data.docs;
    setState(() {
      items = templist.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
      isloaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getmynovels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("your works:"), automaticallyImplyLeading:false),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Createbook(
                initdesc: "",
                initimageurl: "image",
                inittitle: "",
                id: "none",
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: isloaded
          ?  Padding(
                  padding: const EdgeInsets.all(8),
                  child: Wrap(
                   spacing:9.2,
                   runSpacing:9.2,
                    children: items.map((item){return Bookbutton
                      (
                        title: item["title"],
                        coverurl: item["imageurl"],
                        desc: item["desc"],
                        id:item["id"],
                        isuser:false,
                      );}).toList(),
                  ),
                )
              : LoadingPage()
        );
  }
}

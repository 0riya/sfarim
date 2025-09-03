import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/bookbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/widgets/loading.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final searchcontrol = TextEditingController();
  String search="";
  CollectionReference novels = FirebaseFirestore.instance.collection('novels');
  late List<Map<String, dynamic>> items;
  bool isloaded = false;
  getnovels() async {
    var data= await novels.get();
    var templist = data.docs;
    if(search.isNotEmpty)
    {
     List<QueryDocumentSnapshot<Object?>> temp2 =[];
     templist.forEach((element) {
      var data=element.data() as Map<String, dynamic>;
      if(data['title'].toString().contains(search))
      {
        temp2.add(element);
      }
    },);
    templist=temp2;
    }
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
    getnovels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( automaticallyImplyLeading:false),
      body: isloaded
          ? SingleChildScrollView(
              child: Column(
                children: [
                    Row(
                      spacing:15,
                      children: [
                        SizedBox(width:70,),
                        Flexible(child: TextField(decoration:InputDecoration(border:OutlineInputBorder(borderRadius:BorderRadius.circular(30)),hintText:"search"),controller:searchcontrol,)),
                        IconButton(onPressed: () {setState(() {search=searchcontrol.text; isloaded=false;}); getnovels();},icon: Icon(Icons.search,color: Colors.white,),highlightColor:Color.fromARGB(100, 255, 255, 255),style:ButtonStyle( backgroundColor:WidgetStatePropertyAll(Colors.blue),)),
                        SizedBox(width:100,)
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Wrap(
                      spacing: 9.2,
                      runSpacing: 9.2,
                      children: items.map((item) {
                        return Bookbutton(
                          title: item["title"],
                          coverurl: item["imageurl"],
                          desc: item["desc"],
                          id: item["id"],
                          isuser:true,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            )
          : LoadingPage(),
    );
  }
}

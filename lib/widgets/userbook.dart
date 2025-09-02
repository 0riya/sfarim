import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_application_1/widgets/chapterbutton.dart';
import 'package:flutter_application_1/widgets/myroute.dart';
import 'package:flutter_application_1/widgets/tabbar.dart';

class Userbook extends StatefulWidget {
  final String inittitle;
  final String initimageurl;
  final String initdesc;
  final String id;
  const Userbook({
    super.key,
    required this.inittitle,
    required this.initimageurl,
    required this.initdesc,
    required this.id,
  });

  @override
  State<Userbook> createState() => _UserbookState();
}

class _UserbookState extends State<Userbook> {
  final CollectionReference novels = FirebaseFirestore.instance.collection(
    'novels',
  );
  late CollectionReference chapters;
  late List<Map<String, dynamic>> items;
  bool isloaded = false;
  getmychapters() async {
    var data = await chapters.get();
    var templist = data.docs;
    setState(() {
      items = templist.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['chapterid'] = doc.id;
        return data;
      }).toList();
      items.sort((a, b) => a['number'].compareTo(b['number']));
      isloaded = true;
    });
  }

  @override
  void initState() {
    chapters = novels.doc(widget.id).collection('chapters');
    getmychapters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              Myroute(builder: (context) => MyTab(init: 0)),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Container(
            height: 100,
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: AutoSizeText(
              widget.inittitle,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              minFontSize: 16,
              maxLines: 4,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          Row(
            children: [
              Container(
                height: 600,
                width: 375,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Positioned.fill(
                  child: Hero(
                    tag: "coverhero${widget.id}",
                    child: Image.network(widget.initimageurl, fit: BoxFit.fill),
                  ),
                ),
              ),
              SizedBox(width: 80),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                height: 600,
                width: 500,
                child: AutoSizeText(
                  widget.initdesc,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 16,
                  maxLines: 4,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                Ink(
                  width: double.infinity,
                  height: 50,
                  color: Color.fromARGB(200, 194, 194, 194),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
              [
              ],
                  ),
                ),
              ],
            ),
          ),    
          (isloaded)
              ? Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Chapterbutton(
                        isuser: true,
                        id: widget.id,
                        chapterid: items[index]['chapterid'],
                        json: items[index]['json'],
                        number: items[index]['number'],
                        desc: widget.initdesc,
                        title: widget.inittitle,
                        imageurl: widget.initimageurl,
                      );
                    },
                  ),
                )
              : const Text("loading...", style: TextStyle(fontSize: 32)),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/widgets/authservice.dart';
import 'package:flutter_application_1/widgets/chapterbutton.dart';
import 'package:flutter_application_1/widgets/chaptereditor.dart';
import 'package:flutter_application_1/widgets/myroute.dart';
import 'package:flutter_application_1/widgets/tabbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class Createbook extends StatefulWidget {
  final String inittitle;
  final String initimageurl;
  final String initdesc;
  final String id;
  const Createbook({
    super.key,
    required this.inittitle,
    required this.initimageurl,
    required this.initdesc,
    required this.id,
  });

  @override
  State<Createbook> createState() => _CreatebookState();
}

class _CreatebookState extends State<Createbook> {
  @override
  void initState() {
    super.initState();
    bookid = widget.id;
    title = widget.inittitle;
    imageurl = widget.initimageurl;
    desc = widget.initdesc;
    titlecontroller.text = title;
    desccontroller.text = desc;
    chapters = novels.doc(bookid).collection('chapters');
    getmychapters();
  }

  Future<void> imagepick() async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/dmcht4zos/image/upload',
    );
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'coverupload'
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',
            result.files.single.bytes!,
            filename: result.files.single.name,
          ),
        );
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseBody);
        setState(() {
          imageurl = jsonResponse['secure_url'];
        });
      }
    }
  }

  final String userid = Authservice().currentUser!.uid;
  final titlecontroller = TextEditingController();
  final desccontroller = TextEditingController();
  final CollectionReference novels = FirebaseFirestore.instance.collection(
    'novels',
  );
  late List<Map<String, dynamic>> items;
  late String title;
  late String bookid;
  late String imageurl;
  late String desc;
  late CollectionReference chapters;
  bool isloaded = false;
  Future<void> addNovel() {
    setState(() {
      title = titlecontroller.text;
      desc = desccontroller.text;
      if (imageurl == 'image') {
        imageurl = "https://i.imgur.com/LWJmNKD.jpeg";
      }
    });
    return (bookid == "none")
        ? novels
              .add({
                "desc": desc,
                "imageurl": imageurl,
                "userid": userid,
                "title": title,
              })
              .then(
                (value) => setState(() {
                  bookid = value.id;
                  chapters = novels.doc(bookid).collection('chapters');
                }),
              )
              .then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('novel saved'),
                  ),
                ),
              )
              .catchError(
                (error) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.fixed,
                    content: Text('Failed to save novel: $error'),
                  ),
                ),
              )
        : novels
              .doc(widget.id)
              .set({
                "desc": desc,
                "imageurl": imageurl,
                "userid": userid,
                "title": title,
              })
              .then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('novel saved'),
                  ),
                ),
              )
              .catchError(
                (error) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.fixed,
                    content: Text('Failed to save novel: $error'),
                  ),
                ),
              );
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              Myroute(builder: (context) => MyTab(init: 2)),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: SizedBox(
                height: 100,
                width: 400,
                child: TextFormField(
                  controller: titlecontroller,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hint: Text("enter title", style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all(width: 2)),
                    height: 600,
                    width: 375,
                    child: Stack(
                      children: [
                        (imageurl == "image")
                            ? Ink(
                                color: Colors.lightBlueAccent,
                                child: Center(
                                  child: Icon(Icons.add, color: Colors.white),
                                ),
                              )
                            : Positioned.fill(
                                child: Hero(
                                  tag: "coverhero${widget.id}",
                                  child: Image.network(
                                    imageurl,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                imagepick();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 60),
                  SizedBox(
                    height: 600,
                    width: 500,
                    child: TextFormField(
                      controller: desccontroller,
                      style: TextStyle(fontSize: 20),
                      keyboardType: TextInputType.multiline,
                      maxLines: 26,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hint: Text(
                          "enter description",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: addNovel,
                    child: Text("save", style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
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
                      children: [
                        IconButton(
                          onPressed: () {
                            addNovel();
                            Navigator.push(
                              context,
                              Myroute(
                                builder: (context) => Chaptereditor(
                                  id: bookid,
                                  initchapterid: "none",
                                  isuser: false,
                                  json: '[{"insert":"\\n"}]',
                                  desc: desc,
                                  title: title,
                                  imageurl: imageurl,
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.white),
                          ),
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            (isloaded)
                ? ListView.builder(
                  shrinkWrap:true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Chapterbutton(
                      isuser: false,
                      id: bookid,
                      chapterid: items[index]['chapterid'],
                      json: items[index]['json'],
                      number: items[index]['number'],
                      desc: desc,
                      title: title,
                      imageurl: imageurl,
                    );
                  },
                )
                : const Text("loading...", style: TextStyle(fontSize: 32)),
          ],
        ),
      ),
    );
  }
}

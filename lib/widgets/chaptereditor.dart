import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/createbook.dart';
import 'package:flutter_application_1/widgets/myroute.dart';
import 'package:flutter_application_1/widgets/userbook.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chaptereditor extends StatefulWidget {
  const Chaptereditor({
    super.key,
    required this.id,
    required this.initchapterid,
    required this.isuser,
    required this.json,
    required this.imageurl,
    required this.desc,
    required this.title,
  });
  final String id;
  final bool isuser;
  final String initchapterid;
  final int limit = 5000;
  final String json;
  final String title;
  final String desc;
  final String imageurl;

  @override
  State<Chaptereditor> createState() => _ChaptereditortState();
}

class _ChaptereditortState extends State<Chaptereditor> {
  QuillController qcontroller = QuillController.basic();

  @override
  void initState() {
    qcontroller.readOnly = widget.isuser;
    qcontroller.document = Document.fromJson(jsonDecode(widget.json));
    if (!widget.isuser) {
      chapterid = widget.initchapterid;
      qcontroller.document.changes.listen((event) {
        if (event.source == ChangeSource.local) {
          final delta = event.change;
          int chars = 0;
          for (var op in delta.toList()) {
            if (op.isInsert && op.value is String) {
              chars += (op.value as String).length;
            }
          }
          final currentLength = qcontroller.document.toPlainText().length;
          final newLength = currentLength + chars - 2;
          if (newLength > widget.limit) {
            qcontroller.undo();
          }
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    qcontroller.dispose();
    super.dispose();
  }

  late String chapterid;
  CollectionReference novels = FirebaseFirestore.instance.collection('novels');
  Future<void> addChapter() async {
    final String json = jsonEncode(qcontroller.document.toDelta().toJson());
    final chapSnapshot = await novels
        .doc(widget.id)
        .collection('chapters')
        .get();
    final int chapternumber = chapSnapshot.docs.length + 1;
    return (chapterid == "none")
          ? novels
                .doc(widget.id)
                .collection('chapters')
                .add({"json": json, 'number': chapternumber})
                .then(
                  (value) => setState(() {
                    chapterid = value.id;
                  }),
                )
                .then(
                  (value) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('chapter saved'),
                    ),
                  ),
                )
                .catchError(
                  (error) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.fixed,
                      content: Text('Failed to save chapter: $error'),
                    ),
                  ),
                )
          : novels
                .doc(widget.id)
                .collection('chapters')
                .doc(chapterid)
                .update({"json": json})
                .then(
                  (value) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('chapter saved'),
                    ),
                  ),
                )
      ..catchError(
        (error) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.fixed,
            content: Text('Failed to save chapter: $error'),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              Myroute(
                builder: (context) => (widget.isuser)
                    ? Userbook(
                        inittitle: widget.title,
                        initimageurl: widget.imageurl,
                        initdesc: widget.desc,
                        id: widget.id,
                      )
                    : Createbook(
                        inittitle: widget.title,
                        initimageurl: widget.imageurl,
                        initdesc: widget.desc,
                        id: widget.id,
                      ),
              ),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
              vertical: BorderSide(width: 1, color: Colors.grey),
            ),
          ),
          width: 1000,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.isuser)
                    QuillSimpleToolbar(
                      controller: qcontroller,
                      config: const QuillSimpleToolbarConfig(
                        showLink: false,
                        showCodeBlock: false,
                        showIndent: false,
                        showInlineCode: false,
                        showListCheck: false,
                        showListBullets: false,
                        showListNumbers: false,
                      ),
                    ),
                  Expanded(
                    child: QuillEditor.basic(
                      controller: qcontroller,
                      config: const QuillEditorConfig(),
                    ),
                  ),
                ],
              ),
              if (!widget.isuser)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        onPressed: () {
                          addChapter();
                        },
                        icon: Icon(Icons.save),
                        tooltip: "save",
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

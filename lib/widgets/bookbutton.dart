import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_application_1/widgets/createbook.dart';
import 'package:flutter_application_1/widgets/myroute.dart';
import 'package:flutter_application_1/widgets/userbook.dart';

class Bookbutton extends StatelessWidget {
  final String title;
  final String coverurl;
  final String desc;
  final String id;
  final bool isuser;
  const Bookbutton({
    super.key,
    required this.title,
    required this.coverurl,
    required this.desc,
    required this.id,
    required this.isuser,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 125,
      child: Hero(
        tag: "coverhero$id",
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey, width: 1.5),
                ),
                child: Image.network(coverurl, fit: BoxFit.fill),
              ),
            ),
            AutoSizeText(
              title,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              minFontSize: 16,
              maxLines: 4,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            AutoSizeText(
              title,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              minFontSize: 16,
              maxLines: 4,
              style: TextStyle(
                fontSize: 18,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 0.5
                  ..color = Colors.black,
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      Myroute(
                        builder: (context) => (isuser)
                            ? Userbook(
                                initdesc: desc,
                                initimageurl: coverurl,
                                inittitle: title,
                                id: id,
                              )
                            : Createbook(
                                inittitle: title,
                                initimageurl: coverurl,
                                initdesc: desc,
                                id: id,
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

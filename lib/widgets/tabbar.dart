import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/account.dart';
import 'package:flutter_application_1/widgets/creatorpage.dart';
import 'package:flutter_application_1/widgets/explore.dart';
class MyTab extends StatelessWidget {
  final int init;
  const MyTab({super.key,this.init =1});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: init,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
         automaticallyImplyLeading:false,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.explore)),
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.brush)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ExplorePage (),
            AccountPage(),
            CreatorPage(),
          ],
        ),
      ),
    );
  }
}

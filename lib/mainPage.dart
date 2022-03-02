import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'main/favoritePage.dart';
import 'main/mapPage.dart';
import 'main/settingPage.dart';

class MainPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> with SingleTickerProviderStateMixin {
  TabController? controller;
  FirebaseDatabase? _database;
  DatabaseReference? _reference;
  String _databaseURL = 'https://modutour-fd402-default-rtdb.firebaseio.com/';
  String? id;

  @override
  void initState(){
    super.initState();
    controller = TabController(length: 3, vsync: this);
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    _reference = _database!.reference();
  }

  @override
  void dispose(){
    controller!.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    id = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      body: TabBarView(
        children: <Widget>[
          MapPage(),
          FavoritePage(),
          SettingPage(),
        ],
        controller: controller,
      ),
      bottomNavigationBar: TabBar(
        tabs: <Tab>[
          Tab(
            icon: Icon(Icons.map),
          ),
          Tab(
            icon: Icon(Icons.star),
          ),
          Tab(
            icon: Icon(Icons.settings),
          ),
        ],
        labelColor: Colors.amber,
        indicatorColor: Colors.deepOrangeAccent,
        controller: controller,
      ),
    );
  }
}

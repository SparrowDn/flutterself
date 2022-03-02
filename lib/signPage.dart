import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modu_tour/data/user.dart';

class SignPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SignPage();
}

class _SignPage extends State<SignPage> {
  FirebaseDatabase? _database;
  DatabaseReference? _reference;
  String _databaseURL = 'https://modutour-fd402-default-rtdb.firebaseio.com/';

  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;
  TextEditingController? _pwCheckTextController;

  @override
  void initState() {
    super.initState();
    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();
    _pwCheckTextController = TextEditingController();

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    _reference = _database?.reference().child('user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _idTextController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: '4자이상 입력해주세요',
                    labelText: '아이디', border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 20,),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _pwTextController,
                  obscureText: false,
                  maxLines: 1,
                  decoration: InputDecoration(
                      hintText: '6자이상 입력해주세요',
                      labelText: '비밀번호', border: OutlineInputBorder()
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _pwCheckTextController,
                  obscureText: false,
                  maxLines: 1,
                  decoration: InputDecoration(
                      labelText: '비밀번호 확인', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: () {
                if (_idTextController!.value.text.length >= 4 &&
                    _pwTextController!.value.text.length >= 6) {
                  if (_pwTextController!.value.text ==
                      _pwCheckTextController!.value.text) {
                    var bytes = utf8.encode(_pwTextController!.value.text);
                    var digest = sha1.convert(bytes);
                    _reference!
                        .child(_idTextController!.value.text)
                        .push()
                        .set(User(_idTextController!.value.text,
                        digest.toString(), DateTime.now().toIso8601String())
                        .toJson())
                        .then((_) {
                      Navigator.of(context).pop();
                    });
                  } else {
                    makeDialog('비밀번호가 틀립니다');
                  }
                }
                else {
                  makeDialog('길이가 짧습니다');
                }
              },
                child: Text(
                  '회원가입',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
                    Colors.blueAccent)),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,),
        ),
      ),
    );
  }

  void makeDialog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(text),
          );
        }
    );
  }
}

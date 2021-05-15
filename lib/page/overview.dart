import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/data.dart';

class OverViewPage extends StatefulWidget {
  @override
  _OverViewPageState createState() => _OverViewPageState();
}

class _OverViewPageState extends State<OverViewPage> {
  final _list = <QuizObject>[];

  @override
  void initState() {
    super.initState();
    final dirM = Directory("data");
    for (var dir in dirM.listSync()) {
      if (dir is Directory) {
        for (var file in dir.listSync()) {
          if (file is File) {
            _list
                .add(QuizObject.fromJson(json.decode(file.readAsStringSync())));
            print(file);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Overview"),
      ),
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          QuizObject obj = _list[index];
          return ListTile(
            title: Text("${obj.fach}: ${obj.topic}"),
            subtitle: Text("${obj.questions.length} Fragen"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final obj = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => EditorPage()));
          _list.add(obj);
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

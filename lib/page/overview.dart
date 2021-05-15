import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/data.dart';
import 'package:path/path.dart';

class OverViewPage extends StatefulWidget {
  @override
  _OverViewPageState createState() => _OverViewPageState();
}

class _OverViewPageState extends State<OverViewPage> {
  final _list = <QuizObject>[];

  final rootDir = Directory("data");

  @override
  void initState() {
    super.initState();
    _readFilesAndBuildIndex();
  }

  void _readFilesAndBuildIndex() {
    Map index = {};
    for (var dir in rootDir.listSync()) {
      if (dir is Directory) {
        final fach = basename(dir.path);
        print('Fach: $fach');
        index[fach] = [];
        for (var file in dir.listSync()) {
          if (file is File) {
            print(file);
            final qo =
                QuizObject.fromJson(json.decode(file.readAsStringSync()));
            _list.add(qo);

            index[fach].add({
              'fach': qo.fach,
              'topic': qo.topic,
              'image': 'https://i3.ytimg.com/vi/${qo.videoLink}/mqdefault.jpg',
              'questionCount': qo.questions.length,
              'url':
                  'https://jhackt.hns.siasky.net/${qo.fach}/${Uri.encodeFull(qo.topic)}.json',
            });
          }
        }
      }
    }
    File(join(rootDir.path, 'index.json'))
        .writeAsStringSync(json.encode(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Overview"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.upload_outlined,
            ),
            onPressed: () {
              print('building index.json...');
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          QuizObject obj = _list[index];
          return ListTile(
            title: Text("${obj.fach}: ${obj.topic}"),
            subtitle: Text("${obj.questions.length} Fragen"),
            leading: Image.network(
                "https://i3.ytimg.com/vi/${obj.videoLink}/default.jpg"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final obj = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => EditorPage()));
          if (obj?.isValid ?? false) {
            _list.add(obj);

            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

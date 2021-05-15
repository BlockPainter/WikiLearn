import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/data.dart';
import 'package:flutter_application_1/page/overview.dart';
import 'package:path/path.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
      ),
      home: OverViewPage(), //MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class EditorPage extends StatefulWidget {
  EditorPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  var _quizObject = QuizObject();
  String _thUrl;
  final _formKey = GlobalKey<FormState>();
  bool _isAutoV = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Json Editor"),
      ),
      body: Form(
        key: _formKey,
        autovalidate: _isAutoV,
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 700,
              child: Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Invoke "debug painting" (press "p" in the console, choose the
                // "Toggle Debug Paint" action from the Flutter Inspector in Android
                // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                // to see the wireframe for each widget.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                //mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: _quizObject.fach,
                    items: <DropdownMenuItem>[
                      for (var item in ["mathe", "deutsch", "geschichte"])
                        DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                    ],
                    onSaved: (str) {
                      _quizObject.fach = str;
                    },
                    onChanged: (str) {},
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Topic",
                    ),
                    maxLines: 1,
                    onChanged: (str) {
                      _quizObject.topic = str;
                    },
                  ),
                  /*SizedBox(height: 16),
                      if (_thUrl != null)
                        Image.network(_thUrl)
                      else
                        Icon(
                          Icons.upload_file,
                          size: 200,
                        ),*/
                  SizedBox(height: 16),
                  TextFormField(
                    controller: TextEditingController(
                      text: _quizObject.videoLink,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Youtube Video URL",
                    ),
                    maxLines: 1,
                    validator: (str) {
                      if (str.isEmpty) {
                        return "Empty URL!";
                      }

                      try {
                        VideoId.fromString(str);
                      } catch (e) {
                        return "Invalid URL!";
                      }

                      return null;
                    },
                    onChanged: (str) {
                      // item.content = str;
                      try {
                        _quizObject.videoLink = VideoId.fromString(str).value;
                        setState(() {});
                      } catch (e) {
                        _quizObject.videoLink = '';
                      }
                    },

                    /*onChanged: (str) async {
                          print(str);
                          
                            try {
                              final yt = YoutubeExplode();
                              final video = await yt.videos.get(str);
                              _thUrl = video.thumbnails.highResUrl;
                            
                              print(video.thumbnails.highResUrl);
                              print(video.author);
                              
                            } catch (e) {
                              
                              print(e);
                            }
                          }
                          setState(() {});
                        }, */
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      _quizObject.questions.add(QuizQuestion());
                      setState(() {});
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.add), Text("Add a Frage")],
                    ),
                  ),
                  for (var item in _quizObject.questions)
                    Card(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: TextEditingController(
                                text: item.content,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Content",
                              ),
                              onChanged: (str) {
                                item.content = str;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: TextEditingController(
                                text: item.type.toString(),
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Type",
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    item.answers.add(QuizAnswer());
                                    setState(() {});
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add),
                                      Text("Add a Antwort")
                                    ],
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    _quizObject.questions.remove(item);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                            for (var answer in item.answers)
                              Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: TextEditingController(
                                          text: answer.content,
                                        ),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Answer",
                                        ),
                                        onChanged: (str) {
                                          answer.content = str;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text('Ist Korrekt'),
                                          Checkbox(
                                            value: answer.correct,
                                            onChanged: (isIs) {
                                              setState(() {
                                                answer.correct = isIs;
                                              });
                                            },
                                          ),
                                          Spacer(),
                                          IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              item.answers.remove(answer);
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            File file = File(
                join("data", _quizObject.fach, _quizObject.topic + ".json"));
            file.createSync(recursive: true);

            file.writeAsStringSync(json.encode(_quizObject));
            Navigator.of(context).pop(_quizObject);
          } else {
            _isAutoV = true;
            setState(() {});
          }
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

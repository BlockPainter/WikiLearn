import 'dart:convert';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
//import 'dart:html';
import 'package:recase/recase.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/data.dart';
import 'package:flutter_application_1/page/overview.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skynet/src/config.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'model/Language.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting('de_DE', null);

  Intl.defaultLocale = 'de_DE';

  SkynetConfig.host = 'skyportal.xyz';

  prefs = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        accentColor: Colors.green,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        accentColor: Colors.green,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'WikiLearn Editor',
        theme: theme,
        darkTheme: darkTheme,
        home: OverViewPage(),
      ),
    );
  }
}

class EditorPage extends StatefulWidget {
  final QuizObject initialQuizObject;

  EditorPage({Key key, this.initialQuizObject}) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  QuizObject _quizObject;
  String _thUrl;
  final _formKey = GlobalKey<FormState>();
  bool _isAutoV = false;

  @override
  void initState() {
    _quizObject = widget.initialQuizObject ?? QuizObject();
    super.initState();
  }

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
        title: Text(Language["editor.heading"]),
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
                  SizedBox(
                    height: 32,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: _quizObject.subject,
                    items: <DropdownMenuItem>[
                      /*    for (var item in [
                        'mathe',
                        'informatik',
                        'physik',
                        'biologie',
                        'chemie',
                        'deutsch',
                        'englisch',
                        'musik',
                        'politik',
                        'witschaft',
                        'ethik',
                        'geschichte',
                        'sport',
                      ]) */

                      for (var t in QuizSubjectType.values)
                        DropdownMenuItem(
                          value: t,
                          child: Row(
                            children: [
                              Icon(QuizSubjectTypeInfo[t].symbol),
                              SizedBox(
                                width: 10,
                              ),
                              Text(QuizSubjectTypeInfo[t].displayName),
                            ],
                          ),
                        ),
                    ],
                    onSaved: (o) {
                      _quizObject.subject = o;
                    },
                    onChanged: (o) {},
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: TextEditingController(text: _quizObject.topic),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Language["editor.topic"],
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
                  Card(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: TextEditingController(
                            text: _quizObject.videoLink,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: Language["editor.url"],
                          ),
                          maxLines: 1,
                          validator: (str) {
                            if (str.isEmpty) {
                              return Language["editor.url.error.empty"];
                            }

                            try {
                              VideoId.fromString(str);
                            } catch (e) {
                              return Language["editor.url.error.invalid"];
                            }

                            return null;
                          },
                          onChanged: (str) {
                            // item.content = str;
                            try {
                              _quizObject.videoLink =
                                  VideoId.fromString(str).value;
                              setState(() {});
                            } catch (e) {
                              _quizObject.videoLink = '';
                            }
                          },
                        ),
                        if (_quizObject != null &&
                            _quizObject.videoLink.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: (Image.network(
                                "https://i3.ytimg.com/vi/${_quizObject.videoLink}/hqdefault.jpg")),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      _quizObject.questions.add(QuizQuestion());
                      setState(() {});
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        Text(Language["editor.add.question"])
                      ],
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
                                labelText: Language["editor.content"],
                              ),
                              onChanged: (str) {
                                item.content = str;
                              },
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              value: QuizQuestionType.multipleChoice,
                              items: <DropdownMenuItem>[
                                for (var type in QuizQuestionType.values)
                                  DropdownMenuItem(
                                    value: type,
                                    //child: Text(namesQuizQuestionType[type]),
                                    child: Row(children: [
                                      Icon(QuizQuestionTypeInfo[type].symbol),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(QuizQuestionTypeInfo[type]
                                          .displayName),
                                    ]),
                                  )
                              ],
                              onSaved: (o) {
                                item.type = o;
                              },
                              onChanged: (o) {},
                            ),
                            /*TextFormField(
                              controller: TextEditingController(
                                text: item.type.toString(),
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Type",
                              ),
                            ),*/
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
                                      Text(Language["editor.add.answer"])
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
                                          labelText: Language["editor.answer"],
                                        ),
                                        onChanged: (str) {
                                          answer.content = str;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(Language["editor.valid"]),
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

            File file = File(join(
                "data",
                QuizSubjectTypeInfo[_quizObject.subject].name,
                _quizObject.topic + ".json"));
            file.createSync(recursive: true);

            file.writeAsStringSync(json.encode(_quizObject));
            _quizObject.isValid = true;
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

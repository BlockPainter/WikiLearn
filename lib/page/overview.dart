import 'dart:convert';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/data.dart';
// import 'package:flutter_application_1/page/watch.dart';
import 'package:flutter_application_1/utils/skynet.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:skynet/src/skydb.dart';
import 'package:skynet/src/registry.dart';

class OverViewPage extends StatefulWidget {
  @override
  _OverViewPageState createState() => _OverViewPageState();
}

class _OverViewPageState extends State<OverViewPage> {
  var _list = <QuizObject>[];

  final rootDir = Directory("data");

  @override
  void initState() {
    super.initState();
    print("initState");
    _readFilesAndBuildIndex();
  }

  void _readFilesAndBuildIndex() {
    _list = [];

    Map index = {};
    for (var dir in rootDir.listSync()) {
      if (dir is Directory) {
        final subject = basename(dir.path);
        print('subject: $subject');
        index[subject] = [];
        for (var file in dir.listSync()) {
          if (file is File) {
            print(file);
            final qo =
                QuizObject.fromJson(json.decode(file.readAsStringSync()));
            _list.add(qo);

            index[subject].add({
              'subject': QuizSubjectTypeInfo[qo.subject].name,
              'topic': qo.topic,
              'image': 'https://i3.ytimg.com/vi/${qo.videoLink}/mqdefault.jpg',
              'questionCount': qo.questions.length,
              'url':
                  'https://jhackt.hns.siasky.net/${QuizSubjectTypeInfo[qo.subject].name}/${Uri.encodeFull(qo.topic)}.json',
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
        title: Text("overview.heading".tr()),
        actions: [
          IconButton(
              icon: Icon(MdiIcons.translate),
              onPressed: () async {
                final Locale lang = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('settings.chooseLanguage'.tr()),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final lang in context.supportedLocales)
                          ListTile(
                            title: Text({
                              'de': 'Deutsch',
                              'en': 'English',
                            }[lang.languageCode]),
                            onTap: () {
                              Navigator.of(context).pop(lang);
                            },
                          ),
                      ],
                    ),
                  ),
                );
                if (lang != null) {
                  context.setLocale(lang);
                }
              }),
          IconButton(
            icon: Icon(
              Icons.upload_outlined,
            ),
            onPressed: () async {
              print('building index.json...');
              _readFilesAndBuildIndex();
              setState(() {});

              if (!prefs.containsKey('skynetUserKey')) {
                final ctrl = TextEditingController();

                final String value = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Bitte gib deinen Skynet User Key ein'),
                    content: TextField(
                      controller: ctrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Dein Key',
                      ),
                      autofocus: true,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Abbrechen'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(ctrl.text),
                        child: Text('Speichern'),
                      ),
                    ],
                  ),
                );
                if ((value ?? '').isNotEmpty) {
                  prefs.setString('skynetUserKey', value);
                } else {
                  return;
                }
              }

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Änderungen werden hochgeladen...'),
                  content: ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text(
                        'Der Datenordner wird zu Sia Skynet hochgeladen und die DNS Einstellungen werden aktualisiert...'),
                  ),
                ),
                barrierDismissible: false,
              );
              try {
                final skynetUserKey = prefs.getString(
                  'skynetUserKey',
                );
                print(skynetUserKey);

                final skynetUser = await SkynetUser.createFromSeedAsync(
                  await SkynetUser.skyIdSeedToEd25519Seed(
                    skynetUserKey,
                  ),
                );
                print(skynetUser.id);

                final task = DirectoryUploadTask();

                final skylink = await task.uploadDir('data');

                print(skylink);

                final datakey = 'wikilearn';

                await setEntryHelper(
                  skynetUser,
                  datakey,
                  utf8.encode(skylink),
                );
                final res = await getEntry(skynetUser, datakey);
                print(res.entry.revision);

                final skynsRecord =
                    'skyns://ed25519%3A${skynetUser.id}/${hex.encode(hashDatakey(datakey))}';

                print(skynsRecord);

                Navigator.of(context).pop();

                // TODO Show success snackbar or toast
              } catch (e, st) {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Fehler'),
                    content: Text('$e: $st'),
                  ),
                );
              }
            },
          ),
          /*   IconButton(
            icon: Icon(
              Icons.download_outlined,
            ),
            onPressed: () {
              print('building index.json...');
              _readFilesAndBuildIndex();
              setState(() {});
            },
          ), */
          IconButton(
            icon: Icon(MdiIcons.themeLightDark),
            tooltip: 'Change theme',
            onPressed: () {
              if (AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark) {
                AdaptiveTheme.of(context).setLight();
              } else {
                AdaptiveTheme.of(context).setDark();
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          QuizObject obj = _list[index];
          return ListTile(
            title: Text("${obj.subjectCapi}: ${obj.topic}"),
            subtitle: Text('overview.item.questionCount'
                .tr(args: [obj.questions.length.toString()])),
            leading: Image.network(
                "https://i3.ytimg.com/vi/${obj.videoLink}/mqdefault.jpg"),
            /*   onLongPress: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WatchPage(
                    obj,
                  ),
                ),
              );
            }, */
            onTap: () async {
              /* final obj = */ await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditorPage(
                    initialQuizObject: obj,
                  ),
                ),
              );

              _readFilesAndBuildIndex();

              setState(() {});
            },
          );
        },
      ),
      /*bottomNavigationBar: Row(
        children: [
          FloatingActionButton(
            onPressed: () async {
              setState(() {});
            },
            child: Icon(Icons.language),
          ),
          DropdownButtonFormField(
            value: languageManager.getLanguages()[0],
            items: <DropdownMenuItem>[
              for (var l in languageManager.getLanguages())
                DropdownMenuItem(
                  value: l,
                  child: Text(l),
                ),
            ],
          )
        ],
      ),*/
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

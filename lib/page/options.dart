import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OptionsPage extends StatefulWidget {
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("options.heading".tr()),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 700,
            child: Column(
              children: [
                SizedBox(
                  height: 32,
                ),
                DropdownButtonFormField(
                  value: EasyLocalization.of(context).locale,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "options.language".tr(),
                  ),
                  items: <DropdownMenuItem>[
                    for (final lang in context.supportedLocales)
                      DropdownMenuItem(
                        value: lang,
                        child: Text({
                          'de': 'Deutsch',
                          'en': 'English',
                        }[lang.languageCode]),
                      ),
                  ],
                  onSaved: (o) {},
                  onChanged: (o) {
                    context.setLocale(o);
                  },
                ),
                SizedBox(
                  height: 32,
                ),
                DropdownButtonFormField(
                  value: "dark",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "options.color.theme".tr(),
                  ),
                  items: <DropdownMenuItem>[
                    DropdownMenuItem(
                      value: "dark",
                      child: Text("options.color.theme.dark".tr()),
                    ),
                    DropdownMenuItem(
                      value: "light",
                      child: Text("options.color.theme.light".tr()),
                    ),
                  ],
                  onSaved: (o) {},
                  onChanged: (o) {
                    if ("light" == o) {
                      AdaptiveTheme.of(context).setLight();
                    } else {
                      AdaptiveTheme.of(context).setDark();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

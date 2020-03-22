import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:preferences/preferences.dart';
import 'package:txt/route/about.dart';
import 'package:txt/route/themes.dart';
import 'package:txt/widget/system_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  void _sendFeedback(BuildContext context) async {
    String subject = "txt App Feedback";
    String recipient = "marvin@poopjournal.rocks";
    String cc = "mail@reimer.software";
    String url = "mailto:$recipient?cc=$cc&subject=${Uri.encodeQueryComponent(
        subject)}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final snackBar = SnackBar(content: Text('Could not find email program.'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SystemUiOverlayRegion(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'.toUpperCase()),
        ),
        body: PreferencePage([
          PreferenceTitle(
            "General".toUpperCase(),
            leftPadding: 16,
          ),
          ListTile(
            title: Text("App theme"),
            trailing: Icon(
              MdiIcons.recordCircle,
              color: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
            ),
            onTap: () {
              Navigator.pushNamed(context, ThemesScreen.routeName);
            },
          ),
          SwitchPreference(
            "Enable file extensions",
            "file_extensions",
            desc: "Titles will show the file extension",
          ),
          PreferenceTitle(
            "Notes".toUpperCase(),
            leftPadding: 16,
          ),
          SwitchPreference(
            "Enable Microsoft Windows compatibility",
            "windows_compatibility",
          ),
          SwitchPreference(
            "Autocomplete Note titles",
            "autocomplete",
          ),
          PreferenceTitle(
            "Editor".toUpperCase(),
            leftPadding: 16,
          ),
          SwitchPreference(
            "Markdown toolbar",
            "markdown_toolbar",
            desc: "Enable the quick-access toolbar",
          ),
          SwitchPreference(
            "Start with preview",
            "start_with_preview",
            desc: "Show preview when opening notes",
          ),
          PreferenceTitle(
            "About".toUpperCase(),
            leftPadding: 16,
          ),
          ListTile(
            title: Text("About txt"),
            leading: Icon(
              MdiIcons.informationOutline,
              color: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
            ),
            onTap: () {
              Navigator.pushNamed(context, AboutScreen.routeName);
            },
          ),
          ListTile(
            title: Text("Send feedback"),
            leading: Icon(
              MdiIcons.messageAlertOutline,
              color: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
            ),
            onTap: () => _sendFeedback(context),
          ),
        ]),
      ),
    );
  }
}

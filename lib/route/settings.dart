import 'package:flutter/material.dart';
import 'package:pref/pref.dart';
import 'package:txt/route/about.dart';
import 'package:txt/route/themes.dart';
import 'package:txt/widget/system_ui.dart';
import 'package:txt/widget/txt_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  void _sendFeedback(BuildContext context) async {
    String subject = "txt App Feedback";
    String recipient = "marvin@poopjournal.rocks";
    String cc = "mail@reimer.software";
    String url =
        "mailto:$recipient?cc=$cc&subject=${Uri.encodeQueryComponent(subject)}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final snackBar = SnackBar(content: Text('Could not find email program.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SystemUiOverlayRegion(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'.toUpperCase()),
        ),
        body: PrefPage(children: [
          PrefTitle(
            title: Text("General".toUpperCase()),
            padding: EdgeInsets.only(left: 16),
          ),
          ListTile(
            title: Text("App theme"),
            trailing: Icon(
              TxtIcons.theme,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () {
              Navigator.pushNamed(context, ThemesScreen.routeName);
            },
          ),
          PrefSwitch(
            title: Text("Enable file extensions"),
            subtitle: Text("Titles will show the file extension"),
            pref: "file_extensions",
          ),
          PrefTitle(
            title: Text("Notes".toUpperCase()),
            padding: EdgeInsets.only(left: 16),
          ),
          PrefSwitch(
            title: Text("Enable Microsoft Windows compatibility"),
            pref: "windows_compatibility",
          ),
          PrefSwitch(
            title: Text("Autocomplete Note titles"),
            pref: "autocomplete",
          ),
          PrefTitle(
            title: Text("Editor".toUpperCase()),
            padding: EdgeInsets.only(left: 16),
          ),
          PrefSwitch(
            title: Text("Markdown toolbar"),
            subtitle: Text("Enable the quick-access toolbar"),
            pref: "markdown_toolbar",
          ),
          PrefSwitch(
            title: Text("Start with preview"),
            subtitle: Text("Show preview when opening notes"),
            pref: "start_with_preview",
          ),
          PrefTitle(
            title: Text("About".toUpperCase()),
            padding: EdgeInsets.only(left: 16),
          ),
          ListTile(
            title: Text("About txt"),
            leading: Icon(
              TxtIcons.information,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () {
              Navigator.pushNamed(context, AboutScreen.routeName);
            },
          ),
          ListTile(
            title: Text("Send feedback"),
            leading: Icon(
              TxtIcons.feedback,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () => _sendFeedback(context),
          ),
        ]),
      ),
    );
  }
}

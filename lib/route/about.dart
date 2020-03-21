import 'package:flutter/material.dart';
import 'package:txt/widget/system_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return SystemUiOverlayRegion(
      child: Scaffold(
        appBar: AppBar(
          title: Text('About txt'.toUpperCase()),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(
                "assets/icon-squircle.png",
                width: 128,
                height: 128,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Simple text editor/notepad with cloud sync.",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            _ContributorCard(
              name: "Marvin Meißner",
              role: "Sponsor & Publisher",
              avatarPath: "assets/avatars/marvinmeissner.png",
              githubUrl: "https://github.com/CrazyMarvin",
              webUrl: "https://crazymarvin.com/",
            ),
            _ContributorCard(
              name: "Jan Heinrich Reimer",
              role: "Developer",
              avatarPath: "assets/avatars/janheinrichreimer.png",
              githubUrl: "https://github.com/heinrichreimer",
              twitterUrl: "https://twitter.com/H1iReimer",
              webUrl: "https://heinrichreimer.com",
            ),
            _ContributorCard(
              name: "Kevin Aguilar",
              role: "Designer",
              avatarPath: "assets/avatars/kevinaguilar.png",
              githubUrl: "https://github.com/kevttob",
              twitterUrl: "https://twitter.com/kevttob",
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class _ContributorCard extends StatelessWidget {
  final String name;
  final String role;
  final String avatarPath;
  final String githubUrl;
  final String twitterUrl;
  final String webUrl;

  _ContributorCard({
    Key key,
    @required this.name,
    @required this.role,
    @required this.avatarPath,
    this.githubUrl,
    this.twitterUrl,
    this.webUrl,
  }) : super(key: key);

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchGitHub() async {
    _launchUrl(githubUrl);
  }

  _launchTwitter() async {
    _launchUrl(twitterUrl);
  }

  _launchWeb() async {
    _launchUrl(webUrl);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    if (githubUrl != null) {
      buttons.add(
        OutlineButton(
          child: Text("GitHub".toUpperCase()),
          onPressed: _launchGitHub,
        ),
      );
    }
    if (twitterUrl != null) {
      buttons.add(
        OutlineButton(
          child: Text("Twitter".toUpperCase()),
          onPressed: _launchTwitter,
        ),
      );
    }
    if (webUrl != null) {
      buttons.add(
        OutlineButton(
          child: Text("Website".toUpperCase()),
          onPressed: _launchWeb,
        ),
      );
    }

    List<Widget> cardRows = [
      ListTile(
        leading: ClipOval(
          child: Image.asset(
            avatarPath,
            width: 48,
            height: 48,
          ),
        ),
        title: Text(name),
        subtitle: Text(role),
      ),
    ];
    if (buttons.isNotEmpty) {
      cardRows.addAll([
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: ButtonBar(
            children: buttons,
          ),
        ),
      ]);
    }
    return Card(
      child: Column(children: cardRows),
      margin: EdgeInsets.all(8),
    );
  }
}

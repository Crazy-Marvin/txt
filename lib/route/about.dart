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
                width: 96,
                height: 96,
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
            SizedBox(height: 8),
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

  _launchUrl(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final snackBar = SnackBar(content: Text('Could not open link.'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    if (githubUrl != null) {
      buttons.add(
        OutlinedButton(
          child: Text("GitHub".toUpperCase()),
          onPressed: () => _launchUrl(githubUrl, context),
        ),
      );
    }
    if (twitterUrl != null) {
      buttons.add(
        OutlinedButton(
          child: Text("Twitter".toUpperCase()),
          onPressed: () => _launchUrl(twitterUrl, context),
        ),
      );
    }
    if (webUrl != null) {
      buttons.add(
        OutlinedButton(
          child: Text("Website".toUpperCase()),
          onPressed: () => _launchUrl(webUrl, context),
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
      cardRows.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: ButtonBar(
            children: buttons,
          ),
        ),
      );
    }
    return Card(
      child: Column(children: cardRows),
    );
  }
}

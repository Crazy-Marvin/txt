import 'package:flutter/material.dart';
import 'package:pref/pref.dart';

class AppPrefService extends StatelessWidget {
  @required
  final WidgetBuilder _builder;

  const AppPrefService({
    Key key,
    @required WidgetBuilder builder,
  })  : _builder = builder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var service = PrefServiceShared.init(
      defaults: {
        "file_extensions": true,
        "windows_compatibility": false,
        "autocomplete": false,
        "markdown_toolbar": true,
        "start_with_preview": false,
      },
    );
    return FutureBuilder<PrefServiceShared>(
      future: service,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PrefService(
            service: snapshot.data,
            child: Builder(builder: _builder),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

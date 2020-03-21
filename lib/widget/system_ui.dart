import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:txt/themes.dart';

mixin SystemUiRouteObserver<T extends StatefulWidget> on SystemUiState<T>
    implements RouteAware {
  RouteObserver<ModalRoute> _routeObserver;
  ThemesNotifier _themesNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_routeObserver == null) {
      _routeObserver = Provider.of(context, listen: false)
        ..subscribe(this, ModalRoute.of(context));
    }
    if (_themesNotifier == null) {
      _themesNotifier = Provider.of(context, listen: false)
        ..addListener(_onThemeChanged);
    }

    Provider.of<ThemesNotifier>(context);
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    _themesNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    Timer(Duration(milliseconds: 300), updateSystemUiOverlayStyle);
  }

  void _onFocus() {
    Timer(Duration(milliseconds: 100), updateSystemUiOverlayStyle);
  }

  void updateSystemUiOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(systemUIOverlayStyle);
  }

  @override
  void didPopNext() {
    debugPrint("didPopNext($runtimeType)");
    _onFocus();
  }

  @override
  void didPush() {
    debugPrint("didPush($runtimeType)");
    _onFocus();
  }

  @override
  void didPop() {}

  @override
  void didPushNext() {}
}

abstract class SystemUiState<T extends StatefulWidget> extends State<T> {
  SystemUiOverlayStyle get systemUIOverlayStyle =>
      Theme.of(context).systemUiOverlayStyle();
}

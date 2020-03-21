import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:txt/themes.dart';

@immutable
class SystemUiOverlayRegion extends StatelessWidget {
  final Widget child;
  final SystemUiOverlayStyle Function(BuildContext context) builder;

  SystemUiOverlayRegion({
    Key key,
    @required this.child,
    this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: builder != null ? builder(context) : Theme.of(context)
          .systemUiOverlayStyle()
//          .copyWith(systemNavigationBarColor: Colors.yellow, systemNavigationBarDividerColor: Colors.pink, statusBarColor: Colors.green)
      ,
      child: child,
      sized: true,
    );
  }
}

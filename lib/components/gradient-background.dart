import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mliss/constants.dart';

class MlissScaffold extends StatelessWidget {
  final Widget child;
  final bool useSafeArea;

  MlissScaffold({this.child, this.useSafeArea = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kBackgroundLightColor, kBackgroundDarkColor],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          useSafeArea ? SafeArea(child: child) : child,
        ],
      ),
    ));
  }
}

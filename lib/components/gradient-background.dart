import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blue, Colors.red],
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

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Vinyl extends HookWidget {
  final String assetName;
  final bool playing;

  Vinyl({this.assetName, this.playing});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: Duration(seconds: 60));
    final spin = useAnimation(Tween<double>(begin: 0, end: 2)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear)));

    // controller.animateTo(target)

    playing ? controller.repeat() : controller.stop();

    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Transform.rotate(
          angle: spin * 3.1415926535,
          child: Container(
            child: CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage(assetName),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Vinyl extends HookWidget {
  final String imageUrl;
  final bool playing;

  Vinyl({this.imageUrl, this.playing});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: Duration(seconds: 60));
    final spin = useAnimation(Tween<double>(begin: 0, end: 2)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear)));

    playing ? controller.repeat() : controller.stop();

    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Transform.rotate(
          angle: spin * 3.1415926535,
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 140,
                  backgroundImage: AssetImage('assets/images/vinyl.png'),
                ),
                CircleAvatar(
                  radius: 50,
                  // TODO: Temp fallback image
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : AssetImage('assets/music/cover.jpg'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

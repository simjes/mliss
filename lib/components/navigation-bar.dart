import 'package:flutter/material.dart';
import 'package:mliss/bottom-sheets/Playlist.dart';
import 'package:mliss/constants.dart';

class NavigationBar extends StatelessWidget {
  void viewPlaylists(BuildContext context) {
    _showCustomModalBottomSheet(context: context, child: Playlists());
  }

  void browseMusic() {
    print('not implemented');
  }

  void viewQueue() {
    print('not implemented');
  }

  void _showCustomModalBottomSheet({BuildContext context, Widget child}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => BottomSheetBackground(child: child),
        isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NavigationButton(
                icon: Icons.playlist_play,
                onPressed: () {
                  viewPlaylists(context);
                }),
            NavigationButton(
              icon: Icons.search,
              onPressed: browseMusic,
            ),
            NavigationButton(
              icon: Icons.queue_music,
              onPressed: viewQueue,
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  NavigationButton({@required this.icon, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(icon: Icon(icon), onPressed: onPressed),
    );
  }
}

class BottomSheetBackground extends StatelessWidget {
  final Widget child;

  BottomSheetBackground({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50), // TODO: Should not be hardcoded
      // Show handle?
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: kBottomSheetLinearGradient),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: child,
      ),
    );
  }
}

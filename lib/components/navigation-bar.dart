import 'package:flutter/material.dart';
import 'package:mliss/screens/Playlist.dart';

class NavigationBar extends StatelessWidget {
  void viewPlaylists(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context) => Playlists());
  }

  void browseMusic() {
    print('not implemented');
  }

  void viewQueue() {
    print('not implemented');
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

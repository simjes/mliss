import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:mliss/screens/Player.dart';
import 'package:mliss/services/spotify.dart';

class Login extends StatelessWidget {
  static const route = '/login';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FlatButton(
            onPressed: () async {
              var spotifyService = Injector.getInjector().get<SpotifyService>();
              await spotifyService.authenticate();

              if (spotifyService.isAuthenicated) {
                // navigate
                Navigator.pushNamed(context, Player.route);
              }
            },
            child: Text('login')),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mliss/constants.dart';
import 'package:mliss/models/PlaylistDto.dart';
import 'package:mliss/services/spotify.dart';

class Playlists extends HookWidget {
  static const route = '/playlists';
  final spotifyService = Injector.getInjector().get<SpotifyService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: spotifyService.getMyPlaylists(limit: 50),
        builder: (BuildContext context, AsyncSnapshot<PlaylistsDto> snapshot) {
          if (snapshot.hasData) {
            final playlists = snapshot.data.items;

            return ListView.builder(
              itemCount: snapshot.data.items.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];

                return Card(
                  child: ListTile(
                    leading: Image(
                      image: NetworkImage(playlist.images[0].url),
                    ),
                    title: Text(
                      playlist.name,
                    ),
                    subtitle: Text(
                        'by ${playlist.owner.displayName}, ${playlist.tracks.total} tracks'),
                  ),
                );
              },
            );
          }

          if (snapshot.hasError) {
            return Text('placeholder error');
          }

          return SpinKitWave(color: kSliderHandleColor);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mliss/constants.dart';
import 'package:mliss/models/PlaylistDto.dart';
import 'package:mliss/models/PlaylistState.dart';
import 'package:mliss/services/spotify.dart';
import 'package:provider/provider.dart';

// TODO:
// - styling
// - fade in image/blur
// - click to view playlist
// - fast ratio på bildene

class Playlists extends HookWidget {
  static const route = '/playlists';
  final spotifyService = Injector.getInjector().get<SpotifyService>();

  void loadTracks(BuildContext context, String playlistId) async {
    final tracks = await spotifyService.getTracks(playlistId: playlistId);
    Provider.of<PlaylistState>(context, listen: false).setPlaylist(tracks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: spotifyService.getMyPlaylists(limit: 50),
        builder: (BuildContext context, AsyncSnapshot<PlaylistsDto> snapshot) {
          if (snapshot.hasData) {
            final playlists = snapshot.data.items;

            return ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                final image = playlist.images.length != 0
                    ? NetworkImage(playlist.images[0].url)
                    : AssetImage('assets/images/vinyl.png');

                return Card(
                  child: ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      loadTracks(context, playlist.id);
                    },
                    leading: Image(
                      image: image,
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
            // TODO
            return Text('placeholder error');
          }

          return SpinKitWave(color: kSliderHandleColor);
        },
      ),
    );
  }
}

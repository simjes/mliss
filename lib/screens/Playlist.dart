import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:mliss/models/PlaylistDto.dart';
import 'package:mliss/services/spotify.dart';

class Playlists extends HookWidget {
  static const route = '/playlists';

  @override
  Widget build(BuildContext context) {
    final playlists = useState<List<PlaylistDto>>([]);

    loadPlaylists({int offset = 0}) async {
      var spotifyService = Injector.getInjector().get<SpotifyService>();
      var result = await spotifyService.getMyPlaylists(offset: offset);

      playlists.value.addAll(result.items);
    }

    useEffect(() {
      loadPlaylists();
      return null;
    }, []);

    return Scaffold(
      body: ListView.builder(
        itemCount: playlists.value.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              playlists.value[index].name,
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}

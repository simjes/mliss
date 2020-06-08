import 'dart:convert';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart';
import 'package:mliss/models/PlaylistDto.dart';
import 'package:mliss/models/TrackDto.dart';
import 'package:mliss/utils.dart';

class SpotifyService {
  static const _apiUrl = 'https://api.spotify.com/v1';
  static final _accountUrl = 'https://accounts.spotify.com';
  static const _clientId = '5b4181149f684d98a6ff32c5d453397f';
  static const _redirectUri = 'mliss:/';
  // static const _scopes = ['playlist-read-private'];

  // TODO: lag en client som alltid har med token header

  String _token = '';

  get isAuthenicated {
    return _token.isNotEmpty;
  }

  authenticate() async {
    try {
      final result = await FlutterWebAuth.authenticate(
          url:
              "$_accountUrl/authorize?client_id=$_clientId&response_type=token&redirect_uri=$_redirectUri&scope=playlist-read-private",
          callbackUrlScheme: "mliss");

      // TODO: Denne kunne vært mer robust
      _token = Uri.parse(result).fragment.split("=")[1];
    } catch (err) {
      // TODO: Handle this bad boy
      print(err);
    }
  }

  Future<PlaylistsDto> getMyPlaylists({int limit = 5, int offset = 0}) async {
    final response = await get(
        '$_apiUrl/me/playlists?limit=$limit&offset=$offset',
        headers: {'Authorization': 'Bearer $_token'});

    if (response.statusCode == 200) {
      return PlaylistsDto.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load');
  }

  Future<List<TrackDto>> getTracks({String playlistId}) async {
    final response = await get(
        '$_apiUrl/playlists/$playlistId?fields=tracks(items(track(id,name,preview_url,album(images,name))))',
        headers: {'Authorization': 'Bearer $_token'});

    if (response.statusCode == 200) {
      return decodePlaylistJsonToTracks(response.body);

      // final json = jsonDecode(response.body);
      // final tracks = json['tracks'];
      // final items = tracks['items'];
      // List<dynamic> ble = List<dynamic>.from(items);
      // final unwrappedTracks = ble.map((trackMap) {
      //   return trackMap['track'];
      // });

      // final wee = unwrappedTracks.map((track) {
      //   print(track);
      //   return TrackDto.fromJson(track);
      // }).toList();
      // return wee;
    }

    throw Exception('Failed to load');
  }
}

// https://open.spotify.com/track/3RptaQ5Xb8WvtpItZ2f9Hi?si=NoWs2otbS5CGjQIo_v_OEQ

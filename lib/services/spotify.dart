import 'dart:convert';

import 'package:http/http.dart';

class SpotifyService {
  static const _apiUrl = 'https://api.spotify.com/v1';
  static const _clientId = '5b4181149f684d98a6ff32c5d453397f';
  // TODO: Remove if I make repo public
  static const _clientSecret = '';

  static const _tempToken = '';

  Future<dynamic> getDiscoverWeekly() async {
    final response = await get('$_apiUrl/playlists/37i9dQZEVXcDJfzZAoLJdz',
        headers: {'Authorization': 'Bearer $_tempToken'});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load');
  }
}

// https://open.spotify.com/track/3RptaQ5Xb8WvtpItZ2f9Hi?si=NoWs2otbS5CGjQIo_v_OEQ

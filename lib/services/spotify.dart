import 'dart:convert';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart';

class SpotifyService {
  static const _apiUrl = 'https://api.spotify.com/v1';
  static final _accountUrl = 'https://accounts.spotify.com';
  static const _clientId = '5b4181149f684d98a6ff32c5d453397f';
  static const _redirectUri = 'mliss:/';

  String _token = '';

  get isAuthenicated {
    return _token.isNotEmpty;
  }

  authenticate() async {
    try {
      final result = await FlutterWebAuth.authenticate(
          url:
              "$_accountUrl/authorize?client_id=$_clientId&response_type=code&redirect_uri=$_redirectUri",
          callbackUrlScheme: "mliss");

      _token = Uri.parse(result).queryParameters['code'];
    } catch (err) {
      // TODO: Handle this bad boy
      print(err);
    }
  }

  Future<dynamic> getDiscoverWeekly() async {
    final response = await get('$_apiUrl/playlists/37i9dQZEVXcDJfzZAoLJdz',
        headers: {'Authorization': 'Bearer $_token'});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load');
  }
}

// https://open.spotify.com/track/3RptaQ5Xb8WvtpItZ2f9Hi?si=NoWs2otbS5CGjQIo_v_OEQ

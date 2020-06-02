import 'package:flutter_web_auth/flutter_web_auth.dart';

class AuthenticationService {
  static final _accountUrl = 'https://accounts.spotify.com';
  static const _clientId = '5b4181149f684d98a6ff32c5d453397f';
  static const _redirectUri = 'mliss:/';

// Will be empty every time i new up - singletion DI?
  String _token;

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

  get token async {
    if (_token.isEmpty) {
      await authenticate();
    }

    return _token;
  }
}

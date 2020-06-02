import 'package:flutter/material.dart';
import 'package:mliss/services/authenticate.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FlatButton(
            onPressed: () async {
              var auth = AuthenticationService();
              auth.authenticate();
            },
            child: Text('login')),
      ),
    );
  }
}

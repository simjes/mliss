import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:mliss/models/PlaylistState.dart';
import 'package:mliss/screens/Login.dart';
import 'package:mliss/screens/Player.dart';
import 'package:mliss/services/spotify.dart';
import 'package:provider/provider.dart';

void main() {
  ModuleContainer().initialise(Injector.getInjector());

  runApp(MlissApp());
}

class MlissApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlaylistState>(
      create: (context) => PlaylistState(),
      child: MaterialApp(
        title: 'Mliss',
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        initialRoute: Login.route,
        routes: {
          Login.route: (context) => Login(),
          Player.route: (context) => Player(),
        },
      ),
    );
  }
}

class ModuleContainer {
  Injector initialise(Injector injector) {
    injector.map<SpotifyService>((i) => SpotifyService(), isSingleton: true);
    // injector.map<String>((i) => "https://api.com/", key: "apiUrl");
    // injector.map<SomeService>(
    //     (i) => SomeService(i.get<Logger>(), i.get<String>(key: "apiUrl")));

    // injector.map<SomeType>((injector) => SomeType("0"));
    // injector.map<SomeType>((injector) => SomeType("1"), key: "One");
    // injector.map<SomeType>((injector) => SomeType("2"), key: "Two");

    // injector.mapWithParams<SomeOtherType>((i, p) => SomeOtherType(p["id"]));

    return injector;
  }
}

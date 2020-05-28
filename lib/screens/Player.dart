import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:mliss/components/custom-slider-thumb-shape.dart';
import 'package:mliss/components/custom-slider-track-shape.dart';
import 'package:mliss/components/gradient-background.dart';
import 'package:mliss/constants.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  AudioPlayer _player;
  AudioCache _audioCache;
  AudioPlayerState _playerState;

  int _currentSongIndex;

  Duration _duration = Duration();
  Duration _position = Duration();

  List<String> queue = [];

  @override
  void initState() {
    super.initState();
    loadQueue();
    initPlayer();
  }

  void loadQueue() async {
    final manifest =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = jsonDecode(manifest);

    final music = manifestMap.keys
        .where((element) => element.contains('music/'))
        .where((element) => element.contains('.mp3'))
        .map((songPath) => songPath.replaceAll('assets/music/', ""))
        .map((songPath) => Uri.decodeComponent(songPath))
        .toList();

    queue = music;

    if (queue.length > 0) {
      _currentSongIndex = 1;
    }
  }

  void initPlayer() {
    _player = AudioPlayer();
    _audioCache = AudioCache(fixedPlayer: _player, prefix: 'music/');

    _player.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    _player.onAudioPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
      });
    });

    //  _player.onPlayerCompletion.listen((event) {
    //   onComplete();
    //   setState(() {
    //     position = duration;
    //   });
    // });

    _player.onPlayerStateChanged.listen((AudioPlayerState playerState) {
      if (playerState == AudioPlayerState.COMPLETED) {
        print('weee');
      }

      setState(() {
        _playerState = playerState;
      });
    });
  }

  void play() async {
    if (_currentSongIndex != null) {
      final song = queue[_currentSongIndex];
      _audioCache.play(song);
    }
  }

  void nextSong() {
    _currentSongIndex++;
    if (_currentSongIndex > queue.length - 1) {
      _currentSongIndex = 0;
    }

    play();
  }

  void previousSong() {
    if (_position.inSeconds < 2) {
      _currentSongIndex--;
      if (_currentSongIndex < 0) {
        _currentSongIndex = queue.length - 1;
      }
    }

    play();
  }

  void seekToSeconds(int seconds) async {
    final duration = Duration(seconds: seconds);
    await _player.seek(duration);
  }

  @override
  Widget build(BuildContext context) {
    return MlissScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Image(image: AssetImage('assets/music/cover.jpg')),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('California',
                    style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'Prompt',
                        fontStyle: FontStyle.italic)),
                Text('Michael Oakley',
                    style: TextStyle(
                      fontSize: 24,
                      color: kSecondaryTextColor,
                      fontWeight: FontWeight.bold,
                    )),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbColor: kSliderHandleColor,
                    trackHeight: 3,
                    overlayColor: kSliderHandleColor,
                    thumbShape: CustomSliderThumbShape(),
                    trackShape: CustomSliderTrackShape(),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                  ),
                  child: Slider(
                    value: _position.inSeconds.toDouble(),
                    min: 0,
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (double position) {
                      setState(() {
                        seekToSeconds(position.toInt());
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.skip_previous),
                        onPressed: previousSong),
                    ConditionalSwitch.single(
                        context: context,
                        valueBuilder: (context) => _playerState,
                        caseBuilders: {
                          AudioPlayerState.PLAYING: (context) => IconButton(
                              icon: Icon(Icons.pause),
                              onPressed: () => _player.pause()),
                          AudioPlayerState.PAUSED: (context) => IconButton(
                              icon: Icon(Icons.play_arrow),
                              onPressed: () => _player.resume())
                        },
                        fallbackBuilder: (context) => IconButton(
                            icon: Icon(Icons.play_arrow), onPressed: play)),
                    IconButton(
                        icon: Icon(Icons.skip_next), onPressed: nextSong),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

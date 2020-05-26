import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mliss/components/custom-slider-thumb-shape.dart';
import 'package:mliss/components/custom-slider-track-shape.dart';
import 'package:mliss/components/gradient-background.dart';
import 'package:mliss/constants.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  static AudioCache audioCache = AudioCache(prefix: 'music/');
  AudioPlayer player;
  bool playing = false;
  bool seeking = false;
  double _sliderMin = 0;
  double _sliderMax = 0;
  double _sliderValue = 0;

  void play() async {
    player = await audioCache.play(
        'Michael Oakley - California - 03 California (feat. Missing Words).mp3');

    player.onAudioPositionChanged.listen((event) {
      if (!seeking) {
        setState(() {
          _sliderValue = event.inMilliseconds.toDouble();
        });
      }
    });

    final duration = await player.getDuration();

    setState(() {
      playing = true;
      _sliderMax = duration.toDouble();
    });
  }

  void seek(int position) async {
    final duration = Duration(milliseconds: position);
    await player.seek(duration);

    setState(() {
      seeking = false;
    });
  }

  void resume() {
    player.resume();
    setState(() {
      playing = true;
    });
  }

  void pause() {
    player.pause();
    setState(() {
      playing = false;
    });
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
                    value: _sliderValue,
                    min: _sliderMin,
                    max: _sliderMax,
                    onChangeStart: (position) {
                      setState(() {
                        seeking = true;
                      });
                    },
                    onChangeEnd: (position) {
                      final playTime = position.toInt();
                      seek(playTime);
                    },
                    onChanged: (double value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    playing
                        ? IconButton(icon: Icon(Icons.pause), onPressed: pause)
                        : IconButton(
                            icon: Icon(Icons.play_arrow),
                            onPressed: player == null ? play : resume)
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

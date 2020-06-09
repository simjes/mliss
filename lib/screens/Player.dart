import 'package:audioplayers/audioplayers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:mliss/components/custom-slider-thumb-shape.dart';
import 'package:mliss/components/custom-slider-track-shape.dart';
import 'package:mliss/components/gradient-background.dart';
import 'package:mliss/components/navigation-bar.dart';
import 'package:mliss/components/vinyl.dart';
import 'package:mliss/constants.dart';
import 'package:mliss/models/PlaylistState.dart';
import 'package:provider/provider.dart';

class Player extends StatefulWidget {
  static const route = '/player';

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  AudioPlayer _player;
  AudioPlayerState _playerState;

  Duration _duration = Duration();
  Duration _position = Duration();

  @override
  void initState() {
    super.initState();
    initPlayer();

    // TODO: Stop player if new playlist was chosen
  }

  void initPlayer() {
    _player = AudioPlayer();

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

    _player.onPlayerCompletion.listen((event) {
      nextSong();
    });

    _player.onPlayerStateChanged.listen((AudioPlayerState playerState) {
      switch (playerState) {
        case AudioPlayerState.PLAYING:
          // setState(() {
          //   playing = true;
          // });
          break;
        default:
        // setState(() {
        //   playing = false;
        // });
      }

      // if (playerState == AudioPlayerState.COMPLETED) {
      //   print('weee');
      // }

      // if (playerState == AudioPlayerState.PAUSED) {
      //   setState(() {
      //     playing = false;
      //   });
      // }

      setState(() {
        _playerState = playerState;
      });
    });
  }

  void play(String url) async {
    _player.play(url);
  }

  void nextSong() {
    final playlistState = Provider.of<PlaylistState>(context, listen: false);
    playlistState.nextSong();

    final track = playlistState.currentTrack;
    if (track.url != null) {
      play(track.url);
      // snackbar with skipped song
      return;
    }

    // Skip song with missing preview url
    nextSong();
    showSongSkippedToast();
  }

  void previousSong() {
    final playlistState = Provider.of<PlaylistState>(context, listen: false);

    if (_position.inSeconds < 2) {
      playlistState.previousSong();
    }

    final track = playlistState.currentTrack;
    if (track.url != null) {
      play(track.url);
      // snackbar with skipped song
      return;
    }

    // Skip song with missing preview url
    previousSong();
    showSongSkippedToast();
  }

  void seekToSeconds(int seconds) async {
    final duration = Duration(seconds: seconds);
    await _player.seek(duration);
  }

  void showSongSkippedToast() {
    BotToast.showText(text: "Song skipped");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistState>(
      builder: (BuildContext context, value, Widget child) {
        // Might need to optimize this structure

        final currentTrack = value.currentTrack;
        final trackName = currentTrack?.name ?? '';
        // TODO: Eh where is my artist name at
        final artistName = currentTrack?.albumName ?? '';

        // Hmm, ikke alle tracks har preview url - er nok de som er lasta opp selv
        final songUrl = currentTrack?.url;

        return MlissScaffold(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Vinyl(
                imageUrl: currentTrack?.albumImageUrl ?? '',
                playing: _playerState == AudioPlayerState.PLAYING,
              ),
              // Container(
              //   child: Image(
              //     color: kSliderActiveStartColor,
              //     colorBlendMode: BlendMode.softLight,
              //     image: AssetImage('assets/music/cover.jpg'),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('$trackName',
                        style: TextStyle(
                            fontSize: 50,
                            fontFamily: 'Prompt',
                            fontStyle: FontStyle.italic)),
                    Text('$artistName',
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
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 10),
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
                                  icon: Icon(Icons.play_arrow),
                                  onPressed: () {
                                    if (songUrl != null) {
                                      play(songUrl);
                                    }
                                  },
                                )),
                        IconButton(
                            icon: Icon(Icons.skip_next), onPressed: nextSong),
                      ],
                    )
                  ],
                ),
              ),
              NavigationBar()
            ],
          ),
        );
      },
    );
  }
}

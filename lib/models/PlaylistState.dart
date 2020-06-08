import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mliss/models/TrackDto.dart';

class PlaylistState extends ChangeNotifier {
  List<TrackDto> _tracks = [];
  List<String> _queue = [];

  int _currentSongIndex;

  UnmodifiableListView<TrackDto> get tracks => UnmodifiableListView(_tracks);
  UnmodifiableListView<String> get queue => UnmodifiableListView(_queue);

  TrackDto get currentTrack =>
      _tracks.length > 0 ? _tracks[_currentSongIndex] : null;

  void setPlaylist(List<TrackDto> tracks) {
    _tracks = tracks;
    _queue = tracks.map((track) => track.id).toList();
    _currentSongIndex = tracks.length > 0 ? 0 : null;

    notifyListeners();
  }

  void nextSong() {
    _currentSongIndex++;
    if (_currentSongIndex > _queue.length - 1) {
      _currentSongIndex = 0;
    }

    notifyListeners();
  }

  void previousSong() {
    _currentSongIndex--;
    if (_currentSongIndex < 0) {
      _currentSongIndex = _queue.length - 1;
    }

    notifyListeners();
  }
}

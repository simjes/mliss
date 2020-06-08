import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mliss/models/TrackDto.dart';

class PlaylistState extends ChangeNotifier {
  List<TrackDto> _tracks = [];
  List<String> _queue = [];

  UnmodifiableListView<TrackDto> get tracks => UnmodifiableListView(_tracks);
  UnmodifiableListView<String> get queue => UnmodifiableListView(_queue);

  void setPlaylist(List<TrackDto> tracks) {
    _tracks = tracks;
    _queue = tracks.map((track) => track.id).toList();

    notifyListeners();
  }
}

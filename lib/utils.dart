import 'dart:convert';

import 'package:mliss/models/TrackDto.dart';

List<TrackDto> decodePlaylistJsonToTracks(dynamic json) {
  final jsonMap = jsonDecode(json);
  final tracksMap = jsonMap['tracks'];
  final items = List<dynamic>.from(tracksMap['items']);

  final tracks = items
      // Track data is unnecessarily nested inside a new property object
      .map((trackMap) => trackMap['track'])
      .map((track) => TrackDto.fromJson(track))
      .toList();

  return tracks;
}

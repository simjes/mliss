class TrackDto {
  String id;
  String name;
  String url;
  String albumName;
  String albumImageUrl;

  TrackDto();

  factory TrackDto.fromJson(Map<String, dynamic> json) {
    final album = json['album'];
    final images = album['images'];

    return TrackDto()
      ..id = json['id']
      ..name = json['name']
      ..url = json['preview_url']
      ..albumName = album['name']
      ..albumImageUrl = images.length > 0 ? images[0]['url'] : '';
  }
}

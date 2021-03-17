class Album {
  final int totalTracks;
  final String name;
  final String uri;
  List<String> artists;
  final String smallImageUrl;
  final String bigImageUrl;

  Album(
      {this.name,
      this.artists,
      this.totalTracks,
      this.uri,
      this.smallImageUrl,
      this.bigImageUrl});

  factory Album.fromJson(Map<String, dynamic> json) {
    List<String> artists = new List();
    List<dynamic> jsonArtists = json['artists'];
    for (var i = 0; i < jsonArtists.length; i++) {
      artists.add(json['artists'][i]['name']);
    }

    String smallImageUrl;
    String bigImageUrl;
    List<dynamic> jsonImages = json['images'];
    for (var i = 0; i < jsonArtists.length; i++) {
      if (json['images'][i]['height'] == 64) {
        smallImageUrl = json['images'][i]['url'];
      }
      if (json['images'][i]['height'] == 640) {
        bigImageUrl = json['images'][i]['url'];
      }
    }

    return Album(
      name: json['name'],
      artists: artists,
      totalTracks: json['total_tracks'],
      uri: json['uri'],
      smallImageUrl: smallImageUrl,
      bigImageUrl: bigImageUrl,
    );
  }
}

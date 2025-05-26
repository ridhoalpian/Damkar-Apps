class YoutubeVideo {
  final String linkYoutube;

  YoutubeVideo({required this.linkYoutube});

  factory YoutubeVideo.fromJson(Map<String, dynamic> json) {
    return YoutubeVideo(linkYoutube: json['linkYoutube']);
  }
}

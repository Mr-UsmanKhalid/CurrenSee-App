class NewsModel {
  final int id;
  final String title;
  final String summary;
  final String content;
  final String source;
  final DateTime publishedAt;
  final String trend; // up | down | neutral

  const NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.source,
    required this.publishedAt,
    this.trend = 'neutral',
  });
}

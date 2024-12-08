class ArticleModel {
  final String title;
  final String description;
  final String content;
  final String author;
  final String publishedAt;
  final String url;
  final String urlToImage;

  // Constructor
  ArticleModel({
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.publishedAt,
    required this.url,
    required this.urlToImage,
  });

  // Factory constructor to create an ArticleModel from a JSON map
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? 'Unknown',
      publishedAt: json['publishedAt'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
    );
  }

  // Convert the ArticleModel to a JSON map (optional, for saving or API calls)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'publishedAt': publishedAt,
      'url': url,
      'urlToImage': urlToImage,
    };
  }
}

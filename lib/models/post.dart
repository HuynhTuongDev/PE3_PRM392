import 'dart:convert';

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;
  bool isFavorite;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    this.isFavorite = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body'],
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'body': body,
      };

  Post copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
    bool? isFavorite,
  }) {
    return Post(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

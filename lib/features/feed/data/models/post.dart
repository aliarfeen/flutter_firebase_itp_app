class Post {
  final String id;
  final String content;
  final String userName;
  List<String> comments;

  Post({
    required this.id,
    required this.content,
    required this.userName,
    required this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'userName': userName,
      'comments': comments,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      userName: json['userName'],
      comments: json['comments'] == null
          ? <String>[]
          : List<String>.from(json['comments'] as List),
    );
  }

  @override //dont know why but i wanted to create it
  String toString() {
    return 'Post{id: $id, content: $content, userName: $userName, comments: []}';
  }
}

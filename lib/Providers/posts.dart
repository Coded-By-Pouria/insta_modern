class Post {
  final String authorUserName;
  final int likesCount;
  final int commentsCount;
  final List<String> medias;
  final String authorProfileImageURL;
  final String id;

  Post({
    required this.authorUserName,
    required this.likesCount,
    required this.commentsCount,
    required this.medias,
    required this.authorProfileImageURL,
    required this.id,
  });
}

import 'package:flutter/cupertino.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/Providers/comments.dart';
import 'package:insta_modern/Providers/likes.dart';
import 'package:insta_modern/Providers/posts.dart';

enum ActivityTypes {
  likes,
  comments,
  mentions,
  following,
}

class Activities {
  final List<Like> _likes = [
    Like(
      date: DateTime.now(),
      post: POSTS[0],
      username: STORY_LINE[0][1],
      userAvatar: STORY_LINE[0][0],
    ),
    Like(
      date: DateTime.now().subtract(
        const Duration(minutes: 38),
      ),
      post: POSTS[0],
      username: STORY_LINE[0][1],
      userAvatar: STORY_LINE[0][0],
    ),
    Like(
      date: DateTime.now().subtract(
        const Duration(minutes: 4),
      ),
      post: POSTS[1],
      username: STORY_LINE[2][1],
      userAvatar: STORY_LINE[2][0],
    ),
    Like(
      date: DateTime.now().subtract(
        const Duration(minutes: 48),
      ),
      post: POSTS[2],
      username: STORY_LINE[1][1],
      userAvatar: STORY_LINE[1][0],
    ),
  ];

  final List<Comment> _comments = [
    Comment(
      comment:
          "That so nice image man. where do you get this stuffs, that so awsome. can you email some of your pictures pls. i appretiate that . my email is pppppp@gmail.com.",
      date: DateTime.now().subtract(
        const Duration(minutes: 40),
      ),
      post: POSTS[2],
      userAvatar: STORY_LINE[0][0],
      username: STORY_LINE[0][1],
    ),
    Comment(
      comment: "very nice",
      date: DateTime.now().subtract(
        const Duration(minutes: 40),
      ),
      post: POSTS[2],
      userAvatar: STORY_LINE[0][0],
      username: STORY_LINE[0][1],
    ),
    Comment(
      comment: "goo goo ga ga",
      date: DateTime.now().subtract(
        const Duration(minutes: 10),
      ),
      post: POSTS[2],
      userAvatar: STORY_LINE[2][0],
      username: STORY_LINE[2][1],
    ),
    Comment(
      comment:
          "That so nice image man. where do you get this stuffs, that so awsome. can you email some of your pictures pls. i appretiate that . my email is pppppp@gmail.com.",
      date: DateTime.now().subtract(
        const Duration(minutes: 34),
      ),
      post: POSTS[2],
      userAvatar: STORY_LINE[1][0],
      username: STORY_LINE[1][1],
    ),
  ];
  List<BaseActivities> get allActivities {
    final newList = [...likes, ...comments];
    newList.sort((a, b) => b.date.compareTo(a.date));
    return newList;
  }

  List<Like> get likes {
    return [..._likes];
  }

  List<Comment> get comments => [..._comments];
}

abstract class BaseActivities {
  final String username;
  final String userAvatar;
  final DateTime date;
  final Post post;
  BaseActivities({
    required this.date,
    required this.post,
    required this.username,
    required this.userAvatar,
  });
  Widget createActivityWidget();
}

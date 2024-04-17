import 'package:flutter/material.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/Providers/activity.dart';
import 'package:insta_modern/widgets/activity_card.dart';

class Comment extends BaseActivities {
  final String comment;
  Comment({
    required super.date,
    required super.post,
    required super.username,
    required super.userAvatar,
    required this.comment,
  });
  @override
  Widget createActivityWidget() {
    return ActivityCard(
      userAvatar: userAvatar,
      username: username,
      date: date,
      subtitle: comment,
      trailingImage: POSTS[1].medias[0],
      size: TrailingImageSize.large,
      subSubTitle: Row(
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border,
              )),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.comment_outlined),
          ),
        ],
      ),
    );
  }
}

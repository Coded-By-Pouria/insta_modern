import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/Providers/activity.dart';
import 'package:insta_modern/widgets/activity_card.dart';

class Like extends BaseActivities {
  Like({
    required super.date,
    required super.post,
    required super.username,
    required super.userAvatar,
  });

  @override
  Widget createActivityWidget() {
    return ActivityCard(
      userAvatar: userAvatar,
      date: date,
      username: username,
      trailingImage: POSTS[0].medias[0],
      subtitle: "Liked your post.",
    );
  }
}

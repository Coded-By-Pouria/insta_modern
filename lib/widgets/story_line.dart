import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insta_modern/utils/app_theme.dart';

import '../DUMMY_DATA.dart';

class StoryLine extends StatelessWidget {
  const StoryLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 0,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...STORY_LINE
                .map(
                  (e) => StoryItem(
                    imagePath: e[0],
                    userName: e[1],
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

class StoryItem extends StatelessWidget {
  final String? imagePath;
  final String? userName;
  final bool colorFulGradient;
  final Widget? customView;
  final double padding;
  final double width;
  final double radius;
  const StoryItem({
    super.key,
    this.imagePath,
    this.customView,
    this.userName,
    this.padding = 5,
    this.colorFulGradient = true,
    this.width = 80.0,
  })  : assert(!(customView == null && imagePath == null)),
        radius = (width / 2.3);

  Widget _avatarBuilder() => Container(
        width: width,
        height: width,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          border: (colorFulGradient
              ? null
              : Border.all(
                  color: Colors.grey.withAlpha(100),
                  width: 1,
                )),
        ),
        clipBehavior: Clip.hardEdge,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          child: imagePath == null
              ? Center(
                  child: customView,
                )
              : Image.asset(
                  imagePath!,
                  fit: BoxFit.cover,
                ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: padding),
      child: Column(
        children: [
          colorFulGradient
              ? Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: AppTheme.instagramGradient,
                    borderRadius: BorderRadius.all(
                      Radius.circular(radius),
                    ),
                  ),
                  child: _avatarBuilder(),
                )
              : _avatarBuilder(),
          if (userName != null) Text(userName!),
        ],
      ),
    );
  }
}

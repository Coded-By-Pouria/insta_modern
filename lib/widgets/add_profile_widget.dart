import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insta_modern/utils/app_theme.dart';
import 'package:insta_modern/widgets/story_line.dart';

class CustomAddProfile extends StatelessWidget {
  final String profileImageUrl;
  const CustomAddProfile({super.key, required this.profileImageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          StoryItem(imagePath: profileImageUrl),
          Positioned.fill(
            bottom: -10,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    gradient: AppTheme.instagramGradient,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

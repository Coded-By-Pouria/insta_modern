import 'package:flutter/material.dart';
import 'package:insta_modern/widgets/story_line.dart';

enum TrailingImageSize { small, medium, large }

class ActivityCard extends StatelessWidget {
  final String userAvatar;
  final String username;
  final DateTime date;
  final String? trailingImage;
  final String subtitle;
  final Widget? subSubTitle;
  final TrailingImageSize size;
  const ActivityCard({
    super.key,
    required this.userAvatar,
    required this.username,
    required this.date,
    required this.subtitle,
    this.trailingImage,
    this.subSubTitle,
    this.size = TrailingImageSize.medium,
  });

  double _getTralingSize() {
    switch (size) {
      case TrailingImageSize.medium:
        return 60;
      case TrailingImageSize.small:
        return 40;
      case TrailingImageSize.large:
        return 80;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double newSize = _getTralingSize();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StoryItem(
              width: 60,
              imagePath: userAvatar,
              colorFulGradient: true,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    username,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(text: subtitle),
                        TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.black.withAlpha(150),
                                ),
                            text:
                                "${DateTime.now().difference(date).inMinutes} min")
                      ],
                    ),
                  ),
                  if (subSubTitle != null) subSubTitle!,
                ],
              ),
            ),
            const Spacer(),
            trailingImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: SizedBox(
                      width: newSize,
                      height: newSize,
                      child: Image.asset(
                        trailingImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const SizedBox(
                    width: 10,
                  ),
          ],
        ),
      ),
    );
  }
}

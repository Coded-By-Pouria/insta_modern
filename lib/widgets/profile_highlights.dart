import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/widgets/story_line.dart';

class ProfileHighlightList extends StatelessWidget {
  const ProfileHighlightList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        const StoryItem(
          colorFulGradient: false,
          customView: Text(
            "+",
            style: TextStyle(fontSize: 24),
          ),
          userName: "New",
        ),
        ...HIGHLIGHTS
            .map((e) => StoryItem(
                  colorFulGradient: false,
                  imagePath: e[0],
                  userName: e[1],
                ))
            .toList(),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_modern/Providers/activity.dart';
import 'package:insta_modern/Providers/likes.dart';
import 'package:insta_modern/utils/app_theme.dart';
import 'package:insta_modern/widgets/custom_tab_bar.dart';
import 'package:insta_modern/widgets/badge.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _currentIndex = 0;
  List<Widget> activitySubScreens = [];

  List<BaseActivities> _getActivities() {
    final activity = Activities();
    switch (_currentIndex) {
      case 0:
        return activity.allActivities;
      case 1:
        return activity.likes;
      default:
        return activity.comments;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BaseActivities> likes = _getActivities();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Container(
          constraints: const BoxConstraints(maxWidth: 120),
          child: const Text("Activity"),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppTheme.activityScreenBg,
      body: Column(
        children: [
          CustomTabBar(
            onTap: (index) {
              setState(
                () {
                  _currentIndex = index;
                },
              );
            },
            tabData: {
              "All activities": Activities().allActivities.length,
              "Likes": Activities().likes.length,
              "Comments": Activities().comments.length,
              "Mentions": null,
            },
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Text("New(25)"),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => likes[index].createActivityWidget(),
                    childCount: likes.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

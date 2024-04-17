import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/Providers/comments.dart';
import 'package:insta_modern/Providers/posts.dart';
import 'package:insta_modern/utils/app_theme.dart';
import 'package:insta_modern/utils/pinned_sliver_proxy.dart';
import 'package:insta_modern/utils/sliver_with_background.dart';
import 'package:insta_modern/widgets/comment_card.dart';
import 'package:insta_modern/widgets/post_list.dart';
import 'package:overlap_snapping_sliver/overlap_snapping_scroll_widget.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  final height = 450.0;
  final OverlapScrollController _scrollController = OverlapScrollController();

  late double _scrollOffset;

  @override
  void initState() {
    _scrollOffset = 0;
    _scrollController.addListener(() {
      double lastOffset = _scrollOffset;
      double size =
          (_scrollController.position as OverlapScrollPosition).staticSize ??
              height;

      _scrollOffset = clampDouble(_scrollController.offset / size, 0, 1);

      if (_scrollOffset != lastOffset) {
        setState(() {});
      }
    });
    super.initState();
  }

  final _navHeight = 80.0;

  void _onTapHandler() {
    final offset = _scrollController.offset;
    if (offset >= height) {
      _scrollController.animateTo(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.linear,
      );
    } else if (offset == 0) {
      _scrollController.animateTo(
        height,
        duration: const Duration(seconds: 1),
        curve: Curves.linear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.activityScreenBg,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: OverlapScroll(
                controller: _scrollController,
                clipStatic: false,
                staticPart: HomePostItem(
                  post: widget.post,
                  useShadow: false,
                  height: height,
                  comments: [
                    Comment(
                      date: DateTime.now(),
                      post: POSTS[0],
                      username: "maia_",
                      userAvatar: STORY_LINE[2][0],
                      comment:
                          "That was so cute man... how you get these photos ? can you learn me ?",
                    ),
                    Comment(
                      date: DateTime.now(),
                      post: POSTS[0],
                      username: "maia_",
                      userAvatar: STORY_LINE[0][0],
                      comment:
                          "That was so cute man... how you get these photos ? can you learn me ?",
                    ),
                    Comment(
                      date: DateTime.now(),
                      post: POSTS[0],
                      username: "maia_",
                      userAvatar: STORY_LINE[1][0],
                      comment:
                          "That was so cute man... how you get these photos ? can you learn me ?",
                    ),
                  ],
                ),
                slivers: [
                  SliverPersistentHeader(
                    delegate: MySliverPersistHeaderDelegater(
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationZ(
                          pi * (_scrollOffset),
                        ),
                        child: GestureDetector(
                          onTap: _onTapHandler,
                          child: const Icon(Icons.arrow_drop_up),
                        ),
                      ),
                    ),
                    pinned: true,
                  ),
                  PinnedSliver(
                    child: SliverWithBackGround(
                      radius: const Radius.circular(20),
                      color: AppTheme.activityScreenBg,
                      child: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => index == 0
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: CommentCard(),
                                )
                              : index < 50
                                  ? const CommentCard()
                                  : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CommentInputBottomNavigationBar(
                height: _navHeight,
              ),
            ),
          ],
        ));
  }
}

class CommentInputBottomNavigationBar extends StatefulWidget {
  final double height;
  const CommentInputBottomNavigationBar({
    super.key,
    this.height = 80,
  });

  @override
  State<CommentInputBottomNavigationBar> createState() =>
      _CommentInputBottomNavigationBarState();
}

class _CommentInputBottomNavigationBarState
    extends State<CommentInputBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.mainPagePostRadius),
          topRight: Radius.circular(AppTheme.mainPagePostRadius),
        ),
      ),
      height: widget.height,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.activityScreenBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(STORY_LINE[1][0]),
            ),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  label: Text("Add a reply ..."),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
            const Icon(Icons.send),
          ],
        ),
      ),
    );
  }
}

class MySliverPersistHeaderDelegater extends SliverPersistentHeaderDelegate {
  final Widget child;
  MySliverPersistHeaderDelegater({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(alignment: Alignment.center, child: child);
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

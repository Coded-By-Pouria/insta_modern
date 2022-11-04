import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/Providers/comments.dart';
import 'package:insta_modern/Providers/posts.dart';
import 'package:insta_modern/utils/app_theme.dart';
import 'package:insta_modern/utils/overlap_slider.dart';
import 'package:insta_modern/widgets/comment_card.dart';
import 'package:insta_modern/widgets/expandable_positioned.dart';
import 'package:insta_modern/widgets/post_list.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isExpand = false;
  late AnimationController _controller;
  final height = 450.0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  final _navHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    // ModalRoute.of(context). ;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: AppTheme.activityScreenBg,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      // bottomNavigationBar: CommentInputBottomNavigationBar(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: OverlapSlider(
                    maxVal: height,
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
                    menu: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: AppTheme.activityScreenBg,
                        borderRadius: BorderRadius.circular(
                          AppTheme.mainPagePostRadius,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: _navHeight),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemBuilder: (context, index) => index == 0
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: CommentCard(),
                                )
                              : CommentCard(),
                          itemCount: 10,
                        ),
                      ),
                    ),
                    sliderPart: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => index == 0
                            ? const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: CommentCard(),
                              )
                            : CommentCard(),
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   top: (1 - _controller.value) * (height - keyboardHeight),
                //   bottom: 0,
                //   right: 0,
                //   left: 0,
                //   child: Column(
                //     children: [
                //       Container(
                //         alignment: Alignment.center,
                //         child: Transform(
                //           alignment: Alignment.center,
                //           transform: Matrix4.rotationZ(
                //             math.pi * _controller.value,
                //           ),
                //           child: IconButton(
                //             icon: Icon(Icons.arrow_drop_up),
                //             onPressed: () {
                //               setState(
                //                 () {
                //                   _isExpand = !_isExpand;
                //                   switch (_controller.status) {
                //                     case AnimationStatus.completed:
                //                       _controller.reverse();
                //                       break;
                //                     case AnimationStatus.dismissed:
                //                       _controller.forward();
                //                       break;
                //                     default:
                //                   }
                //                 },
                //               );
                //             },
                //           ),
                //         ),
                //       ),
                //       Expanded(
                //         child: Container(
                //           clipBehavior: Clip.hardEdge,
                //           decoration: BoxDecoration(
                //             color: AppTheme.activityScreenBg,
                //             borderRadius: BorderRadius.circular(
                //               AppTheme.mainPagePostRadius,
                //             ),
                //           ),
                //           child: Padding(
                //             padding: EdgeInsets.only(bottom: _navHeight),
                //             child: ListView.builder(
                //               controller: _scrollController,
                //               itemBuilder: (context, index) => index == 0
                //                   ? const Padding(
                //                       padding: EdgeInsets.only(top: 10),
                //                       child: CommentCard(),
                //                     )
                //                   : CommentCard(),
                //               itemCount: 10,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                //   // expandPartController: _scrollController,
                // ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CommentInputBottomNavigationBar(
                    height: _navHeight,
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
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.mainPagePostRadius),
          topRight: Radius.circular(AppTheme.mainPagePostRadius),
        ),
      ),
      height: widget.height,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
            SizedBox(
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
            Icon(Icons.send),
          ],
        ),
      ),
    );
  }
}

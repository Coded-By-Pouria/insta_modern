import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/Providers/comments.dart';
import 'package:insta_modern/Providers/posts.dart';
import 'package:insta_modern/utils/app_theme.dart';
import 'package:insta_modern/utils/custom_list_view.dart';

class HomePostList extends StatelessWidget {
  const HomePostList({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomListView.builder(
      primary: false,
      shrinkWrap: true,
      itemExtent: 450,
      itemCount: 6,
      itemBuilder: (context, index) => HomePostItem(
        post: POSTS[index],
        useShadow: index == 0 ? false : true,
      ),
    );
  }
}

class HomePostItem extends StatefulWidget {
  final Post post;
  final bool useShadow;
  final double? height;
  final List<Comment>? comments;
  final bool _showBottomComment;
  final bool _isMultiMedia;
  final VoidCallback? onTap;

  HomePostItem({
    super.key,
    required this.post,
    this.height,
    required this.useShadow,
    this.comments,
    this.onTap,
  })  : _showBottomComment = comments != null && comments.isNotEmpty,
        _isMultiMedia = post.medias.length > 1;

  @override
  State<HomePostItem> createState() => _HomePostItemState();
}

class _HomePostItemState extends State<HomePostItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPostLiked = false;
  PageController? _pageController;

  final bottomOffset = 60.0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.addListener(() {
      setState(() {});
    });
    if (widget._isMultiMedia) {
      _initPageController();
    }

    super.initState();
  }

  void _initPageController() {
    _pageController = PageController();
    _pageController!.addListener(_pageListener);
  }

  double page = 0;
  void _pageListener() {
    setState(() {
      page = _pageController!.page!;
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _stackProvider(double size) {
    List<Widget> children = [];
    const sizePerRadius = 2.66;
    final br = size / sizePerRadius;
    const overlapOffset = 15;
    final totalWidth = 3 * size - 2 * overlapOffset;
    for (int index = 0; index < 3; index++) {
      children.add(
        Positioned(
          // left: (size * index++) - overlapOffset * index,
          left: totalWidth - size * (index + 1) + overlapOffset * index,
          child: SizedBox(
            width: size,
            height: size,
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(br),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(br),
                child: Image.asset(
                  widget.comments![index].userAvatar,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Stack(
      children: children,
    );
  }

  Widget _slideIndicatorWidget() {
    int index = 0;
    const baseWidth = 10.0;
    return Row(
      children: widget.post.medias.map((media) {
        double clamped = clampDouble(1 - (page - index++).abs(), 0, 1);
        double colorClamped = clampDouble(clamped, 0.5, 1);
        return Padding(
          padding: const EdgeInsets.only(
            right: 5,
          ),
          child: Container(
            width: clamped * 20 + baseWidth,
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(255, 255, 255, colorClamped),
            ),
          ),
        );
      }).toList(),
    );
  }

  late double _tapX;

  void _onTapHanler() {
    FocusScope.of(context).requestFocus(FocusNode());
    final dx = _tapX;
    final width = MediaQuery.of(context).size.width;
    int newPage = -1;
    if (dx < 50) {
      newPage = page.floor() - 1;
    } else if ((width - dx).abs() < 50) {
      newPage = page.floor() + 1;
    }
    if (newPage >= 0 && newPage < widget.post.medias.length) {
      _pageController?.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }

  void _doubleTapHandler() {
    setState(
      () {
        _isPostLiked = true;

        _controller.forward();
        Future.delayed(
          const Duration(milliseconds: 800),
          () {
            _controller.reverse();
          },
        );
      },
    );
  }

  Widget _mediaWidgetProvider() {
    int mediaIndex = 0;

    final child = ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(AppTheme.mainPagePostRadius),
      ),
      child: PageView(
        controller: _pageController,
        children: widget.post.medias
            .map(
              (e) => Image.asset(
                widget.post.medias[mediaIndex++],
                fit: BoxFit.cover,
              ),
            )
            .toList(),
      ),
    );
    final detector = GestureDetector(
      onDoubleTap: _doubleTapHandler,
      onTapDown: (details) {
        _tapX = details.globalPosition.dx;
      },
      onTap: widget.onTap ?? _onTapHanler,
      child: child,
    );
    return detector;
  }

  @override
  Widget build(BuildContext context) {
    Image postImageWidget = Image.asset(widget.post.authorProfileImageURL);
    return Hero(
      tag: widget.post.id,
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppTheme.mainPagePostRadius),
          ),
        ),
        child: Container(
          height: widget.height,
          decoration: widget.useShadow
              ? BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(150),
                        offset: const Offset(0, -5),
                        blurRadius: 25,
                        spreadRadius: 5),
                  ],
                )
              : null,
          child: Stack(
            children: [
              Positioned.fill(
                child: _mediaWidgetProvider(),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: postImageWidget,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.post.authorUserName,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (widget._isMultiMedia)
                Positioned(
                  top: 30,
                  right: 20,
                  child: _slideIndicatorWidget(),
                ),
              Positioned(
                bottom: bottomOffset,
                left: 20,
                right: 20,
                child: _PostBottomIcons(
                  isLiked: _isPostLiked,
                  likesCount: widget.post.likesCount,
                  commentsCount: widget.post.commentsCount,
                ),
              ),
              if (widget._showBottomComment)
                Positioned(
                  bottom: 0,
                  left: 20,
                  right: 20,
                  top: widget.height! - bottomOffset,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 35,
                        width: 3 * 35 - 20,
                        child: _stackProvider(35),
                      ),
                      Expanded(
                        child: Text(
                          widget
                              .comments![
                                  Random().nextInt(widget.comments!.length)]
                              .comment,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppTheme.activityScreenBg,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "more",
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // if (_displayLike)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: _controller.value,
                    child: Transform.scale(
                      scale: _controller.value,
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset("assets/images/utils/like.png"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostBottomIcons extends StatelessWidget {
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  const _PostBottomIcons({
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
  });

  Widget _likeButtonBuilder() {
    final mainChild = Row(
      children: [
        const Icon(
          Icons.favorite,
          color: Colors.white,
          size: 22,
        ),
        Text(
          likesCount.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 70,
        color: isLiked
            ? const Color.fromARGB(255, 207, 28, 67)
            : Colors.white.withAlpha(100),
        child: isLiked
            ? mainChild
            : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: mainChild,
              ),
      ),
    );
  }

  Widget _commentSectionBuilder() {
    return Row(
      children: [
        const Icon(Icons.mode_comment_rounded, color: Colors.white),
        Text(
          commentsCount.toString(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _likeButtonBuilder(),
        const SizedBox(
          width: 10,
        ),
        _commentSectionBuilder(),
        const SizedBox(
          width: 20,
        ),
        Transform.rotate(
          angle: -pi / 6,
          child: const Icon(Icons.send, color: Colors.white),
        ),
        const Spacer(),
        const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.bookmark_outline,
              color: Colors.white,
            ))
      ],
    );
  }
}

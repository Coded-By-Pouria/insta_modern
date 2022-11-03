import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/Providers/posts.dart';
import 'package:insta_modern/utils/app_theme.dart';

class ExploreMainSliver extends StatelessWidget {
  const ExploreMainSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ExploreMainLayout(
          posts: [
            POSTS[index],
            POSTS[index + 1],
            POSTS[index + 2],
            POSTS[index + 3],
            POSTS[index + 4],
          ],
          invert: index % 2 != 0,
        ),
        childCount: (POSTS.length / 5).ceil(),
      ),
    );
  }
}

class ExploreMainLayout extends StatelessWidget {
  /// 5-tuple of posts to be displayed
  final List<Post> posts;
  final bool invert;
  const ExploreMainLayout({
    super.key,
    required this.posts,
    this.invert = false,
  }) : assert(posts.length < 6 && posts.length > 0);

  Widget _sizedBox(
    double width,
    double height,
    BorderRadius radius,
    int index,
  ) {
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(2.5),
        child: ClipRRect(
          borderRadius: radius,
          child: Image.asset(
            POSTS[index].medias[0],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  List<Widget> _invertiblePart(double width, int counter, int length) {
    const rightMainRadius = BorderRadius.only(
      bottomRight: Radius.circular(AppTheme.borderRadius),
      topRight: Radius.circular(AppTheme.borderRadius),
      topLeft: Radius.circular(AppTheme.borderRadius),
    );

    const leftMainRadius = BorderRadius.only(
      topLeft: Radius.circular(AppTheme.borderRadius),
      bottomLeft: Radius.circular(AppTheme.borderRadius),
      topRight: Radius.circular(AppTheme.borderRadius),
    );
    final list = [
      Expanded(
        child: Column(
          children: [
            _sizedBox(
              width,
              width,
              invert ? rightMainRadius : leftMainRadius,
              counter++,
            ),
            if (counter < length)
              _sizedBox(
                width,
                width,
                invert
                    ? const BorderRadius.only(
                        topRight: Radius.circular(AppTheme.borderRadius),
                        bottomRight: Radius.circular(AppTheme.borderRadius),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(AppTheme.borderRadius),
                        bottomLeft: Radius.circular(AppTheme.borderRadius),
                      ),
                counter++,
              ),
          ],
        ),
      ),
      if (counter < length)
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(2.5),
            child: ClipRRect(
              borderRadius: invert ? leftMainRadius : rightMainRadius,
              child: Image.asset(
                POSTS[counter++].medias[0],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
    ];
    return invert ? list.reversed.toList() : list;
  }

  Widget prepareLayout() {
    // if(posts )
    int counter = 0;
    int length = posts.length;
    return LayoutBuilder(
      builder: (ctx, cons) {
        final width = cons.maxWidth / 2;
        final height = width;
        return Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _invertiblePart(width, counter, length),
              ),
            ),
            if ((counter += 3) < length)
              LayoutBuilder(
                builder: (ctx, cons) => Row(
                  children: [
                    _sizedBox(
                        width,
                        height,
                        const BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.borderRadius),
                          bottomLeft: Radius.circular(AppTheme.borderRadius),
                        ),
                        counter++),
                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(2.5),
                    //     child: ClipRRect(
                    //       borderRadius: const BorderRadius.only(
                    //         topLeft: Radius.circular(AppTheme.borderRadius),
                    //         bottomLeft: Radius.circular(AppTheme.borderRadius),
                    //       ),
                    //       child: Image.asset(
                    //         POSTS[1].postImageURL,
                    //         fit: BoxFit.cover,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    if (counter < length)
                      _sizedBox(
                          width,
                          height,
                          const BorderRadius.only(
                            topRight: Radius.circular(AppTheme.borderRadius),
                            bottomRight: Radius.circular(AppTheme.borderRadius),
                          ),
                          counter++),
                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(2.5),
                    //     child: ClipRRect(
                    //       borderRadius: const BorderRadius.only(
                    //         topRight: Radius.circular(AppTheme.borderRadius),
                    //         bottomRight:
                    //             Radius.circular(AppTheme.borderRadius),
                    //       ),
                    //       child: Image.asset(
                    //         POSTS[1].postImageURL,
                    //         fit: BoxFit.cover,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return prepareLayout();
  }
}

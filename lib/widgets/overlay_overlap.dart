import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/screens/profile_screen.dart';
import 'package:insta_modern/widgets/overlap_slider.dart';

class OverlayOverlap extends StatefulWidget {
  const OverlayOverlap({super.key});

  @override
  State<OverlayOverlap> createState() => _OverlayOverlapState();
}

class _OverlayOverlapState extends State<OverlayOverlap> {
  late ScrollController _controller;
  final GlobalKey<State> _gk = GlobalKey();
  final VerticalDragGestureRecognizer dr = VerticalDragGestureRecognizer();
  bool isDragging = false;

  double _slideOffset = 0;

  double? _maxHeight;

  double get slideOffset => _slideOffset;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(() {
      // print(_controller.offset);
      final height = _maxHeight!;
      final offset = _controller.offset;
      print("height $offset");
      if (slideOffset <= height) {
        _slideOffset += offset;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    dr.dispose();
  }

  void _handleDragDown(DragDownDetails details) {
    if (!isDragging) {
      isDragging = true;
      setState(() {});
    }
  }

  void _handleDragEnd(DragEndDetails _) {
    _dragEnd();
  }

  void _dragEnd() {
    if (isDragging) {
      isDragging = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (ctx) => Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: ProfileDetails(
                key: _gk,
              )),
        ),
        OverlayEntry(
          builder: (ctx) => LazyBuilder(builder: (ctx, cons) {
            _maxHeight ??= (_gk.currentContext!.findRenderObject() as RenderBox)
                .size
                .height;
            return Positioned(
              bottom: 0,
              top: (_maxHeight! + _slideOffset),
              child: Listener(
                onPointerDown: (event) {
                  dr
                    ..onDown = _handleDragDown
                    ..onEnd = _handleDragEnd
                    ..onCancel = _dragEnd;
                },
                child: CustomScrollView(
                  controller: _controller,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 5),
                      sliver: SliverGrid(
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 3,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          repeatPattern: QuiltedGridRepeatPattern.inverted,
                          pattern: [
                            const QuiltedGridTile(2, 2),
                            const QuiltedGridTile(1, 1),
                            const QuiltedGridTile(1, 1),
                          ],
                        ),
                        delegate: SliverChildBuilderDelegate(
                          childCount: 3,
                          (context, index) => Image.asset(
                            POSTS[index].medias[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Image.asset(
                          POSTS[index + 3].medias[0],
                          fit: BoxFit.cover,
                        ),
                        childCount: POSTS.length - 3,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        crossAxisCount: 3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

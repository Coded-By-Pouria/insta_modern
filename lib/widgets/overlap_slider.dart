import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/screens/profile_screen.dart';
import 'package:insta_modern/utils/slider_sliver/custom_overlap_sliver.dart';
import 'package:insta_modern/widgets/profile_highlights.dart';

class OverlapSlider extends StatefulWidget {
  const OverlapSlider({super.key});

  @override
  State<OverlapSlider> createState() => _OverlapSliderState();
}

// هدف استفاده از ویجت استک و gestureDetector برای تشخیص رویداد های اسکرول و جابجا و تغییر سایز دادن قسمت اسلایدر
// هست. اما چالش پیش رو چند مورد هست
// 1- اینکه ما چجوری دو تا ویجتی رو در حالت اولیه مثل یک ستون کنار هم قرار بدیم برای اینکار ما
// برای موقعیت دهی ویجت دوم ما نیاز به ارتفاع ویجت اول داریم و بدست اوردن این ارتفاع در زمان
// ساخت درخت ویجت امکان پذیر نیست. پس ما یک ویجت به نام lazyBuilder ساختیم که دقیقا خود layoutBuilder هست و فقط با StackParentData
// همگام شده. هدف هم این بود که فرآیند بیلد ویجت به هنگام فاز چیدمان تعویض بیفته. تا ما به ارتفاع ویجت قلی با استفاده از کلید دسترسی داشته باشیم
// 2- ویجت استک تمام ارتفاع در دسترس خودش رو در اختیار نمیگره و این باعث میشه فرآیند لمس یا هیت تست توی
// قسمتایی که اسکرول قرار داره اما خود استک نیست، اتفاق نیفته
class _OverlapSliderState extends State<OverlapSlider> {
  final GlobalKey<State> _gk = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: ProfileDetails(
            key: _gk,
          ),
        ),
        LazyBuilder(
          builder: (ctx, cons) => Positioned(
            bottom: 0,
            top: (_gk.currentContext!.findRenderObject() as RenderBox)
                .size
                .height,
            child: CustomScrollView(
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LazyBuilder extends LayoutBuilder {
  LazyBuilder({
    required super.builder,
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderLazyBuilder();
  }
}

class RenderLazyBuilder extends RenderBox
    with
        RenderObjectWithChildMixin<RenderBox>,
        RenderConstrainedLayoutBuilder<BoxConstraints, RenderBox> {
  void newPosition(double? top, double? right, double? bottom, double? left) {
    markNeedsLayout();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! StackParentData) {
      child.parentData = StackParentData();
    }
  }

  @override
  void performLayout() {
    // BoxConstraints childConstraints = this.constraints;
    rebuildIfNecessary();
    if (child != null) {
      final pd = child!.parentData as StackParentData;
      pd.width = constraints.maxWidth;
      // (parentData as StackParentData)
      //   ..top = pd.top
      //   ..bottom = pd.bottom
      //   ..right = pd.right
      //   ..left = pd.left
      //   ..width = pd.width
      //   ..height = pd.height;
      print("iiiiiiiisssssssss Positioned : ${constraints} - ${pd.bottom}");
      RenderStack;
      RenderStack.layoutPositionedChild(
        child!,
        pd,
        constraints.biggest,
        Alignment.centerLeft,
      );
      // print(
      //     "sisssze ${((parent as RenderBox).parentData as BoxParentData).offset}");

      // pd.offset = Offset(pd.left ?? 0, pd.top ?? 0);]
      size = constraints.constrain(child!.size);
      print("size : ${pd.top} - ${child!.size.height}");
    } else {
      size = constraints.biggest;
    }
  }

  // @override
  // bool hitTest(BoxHitTestResult result, {required Offset position}) {
  //   return child!.hitTest(result, position: position);
  // }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final StackParentData childParentData =
        child!.parentData! as StackParentData;
    print(childParentData.offset);
    final Matrix4 transform = Matrix4.identity();
    applyPaintTransform(child!, transform);
    final bool isHit = result.addWithPaintOffset(
      offset: childParentData.offset,
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        assert(transformed == position - childParentData.offset);
        return child!.hitTest(result, position: transformed);
      },
    );
    if (isHit) {
      return true;
    }
    return false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final StackParentData childParentData =
          child!.parentData as StackParentData;
      context.paintChild(child!, childParentData.offset + offset);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/widgets/add_profile_widget.dart';
import 'package:insta_modern/widgets/profile_highlights.dart';
import 'package:insta_modern/widgets/badge.dart' as MyBadge;
import 'package:overlap_snapping_sliver/overlap_snapping_scroll_widget.dart';

class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({super.parent});

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final tolerance = this.tolerance;
    if ((velocity.abs() < tolerance.velocity) ||
        (velocity > 0.0 && position.pixels >= position.maxScrollExtent) ||
        (velocity < 0.0 && position.pixels <= position.minScrollExtent)) {
      return null;
    }
    return ClampingScrollSimulation(
      position: position.pixels,
      velocity: velocity,
      friction: 0.5, // <--- HERE
      tolerance: tolerance,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ScrollController? _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("Device size : ${MediaQuery.of(context).size.height}");
    return Scaffold(
        appBar: AppBar(
          leading: const IconButton(
            icon: Icon(Icons.settings),
            onPressed: null,
          ),
          actions: const [
            MyBadge.Badge(
              value: "",
              color: Colors.red,
              child: Icon(
                Icons.mail_outline_rounded,
                color: Colors.grey,
              ),
            )
          ],
          title: Container(
            constraints: const BoxConstraints(maxWidth: 120),
            child: SvgPicture.asset("assets/svgs/logo.svg"),
          ),
          centerTitle: true,
        ),
        body: OverlapScroll(
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
          staticPart: const ProfileDetails(),
        ));
  }
}

typedef ItemBuilderCallback = void Function(
    BuildContext context, int headerOffset);

class HeaderSliver extends SingleChildRenderObjectWidget {
  const HeaderSliver({super.child, super.key});
  @override
  RenderHeaderSliver createRenderObject(BuildContext context) {
    return RenderHeaderSliver();
  }
}

class RenderHeaderSliver extends RenderSliverSingleBoxAdapter {
  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    // final SliverConstraints constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    // print("constraints : ${constraints.scrollOffset}");
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      paintOrigin: constraints.scrollOffset,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child!, constraints, geometry!);
  }
}

class ProfilePersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return ProfileDetails();
  }

  @override
  double get maxExtent => 300;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  Widget _accountData() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("26,3K"),
            Text("Followers"),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        CustomAddProfile(profileImageUrl: "assets/images/profs/prof1.jpg"),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("884"),
            Text("Following"),
          ],
        ),
      ],
    );
  }

  Widget _accountsCareer() => RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: "Alice Bagheri | ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: "Photographer",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );

  Widget _accountDescription() => const Text(
        "i love to travel over the world and take picture from everything i see. bla bla bla",
        textAlign: TextAlign.center,
      );

  Widget _profButtons() {
    return const Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: null,
            child: Text("Edit Profile"),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: null,
            child: Text("Statistics"),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: null,
            child: Text("Contact"),
          ),
        ),
      ],
    );
  }

  /// before version
  // Widget build(BuildContext context) {
  //   return ClipRect(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Expanded(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               _accountData(),
  //               _accountsCareer(),
  //               _accountDescription(),
  //               _profButtons(),
  //               ProfileHighlightList(),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _accountData(),
        _accountsCareer(),
        _accountDescription(),
        _profButtons(),
        const ProfileHighlightList(),
      ],
    );
  }
}

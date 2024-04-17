import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/widgets/add_profile_widget.dart';
import 'package:insta_modern/widgets/profile_highlights.dart';
import 'package:insta_modern/widgets/badge.dart' as my_badge;
import 'package:overlap_snapping_sliver/overlap_snapping_scroll_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
            my_badge.Badge(
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

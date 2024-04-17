import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/screens/post_detail_screen.dart';
import 'package:insta_modern/utils/custom_list_view.dart';
import 'package:insta_modern/widgets/post_list.dart';
import 'package:insta_modern/widgets/story_line.dart';
import 'package:insta_modern/widgets/badge.dart' as mybadge;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _controller = ScrollController();
  bool isOffsetDone = false;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.offset > 150) {
        isOffsetDone = true;
      } else {
        isOffsetDone = false;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          icon: Icon(Icons.settings),
          onPressed: null,
        ),
        actions: const [
          mybadge.Badge(
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
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: StoryLine(),
          ),
          CustomSliverFixedExtentList(
            itemExtent: 450,
            delegate: SliverChildBuilderDelegate(
              (context, index) => HomePostItem(
                post: POSTS[index],
                useShadow: index == 0 ? false : true,
                onTap: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (ctx, animation, _) {
                      return PostDetailScreen(
                        post: POSTS[index],
                      );
                    },
                  ),
                ),
              ),
              childCount: POSTS.length,
            ),
          ),
        ],
      ),
    );
  }
}

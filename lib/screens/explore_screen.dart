import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_modern/DUMMY_DATA.dart';
import 'package:insta_modern/utils/app_theme.dart';
import 'package:insta_modern/widgets/custom_tab_bar.dart';
import 'package:insta_modern/widgets/explore_main_sliver.dart';

class EcplorseScreen extends StatefulWidget {
  const EcplorseScreen({super.key});

  @override
  State<EcplorseScreen> createState() => _EcplorseScreenState();
}

class _EcplorseScreenState extends State<EcplorseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.activityScreenBg,
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.activityScreenBg,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      label: Text("search"),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search)),
                ),
              ),
            ),
            Icon(
              Icons.apps,
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CustomTabBar(
                onTap: (index) {},
                tabData: {
                  "Reels": null,
                  "IGTV": null,
                  "Store": null,
                  "Game": null,
                },
              ),
            ),
            ExploreMainSliver(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:insta_modern/DUMMY_DATA.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  Widget _buttonProvider(Widget content, VoidCallback onPressed) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        backgroundColor: MaterialStateProperty.all(Colors.grey),
      ),
      onPressed: onPressed,
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  STORY_LINE[0][0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(STORY_LINE[0][1]),
                const Text("Nice, you are so beautiful."),
              ],
            ),
            // Spacer(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buttonProvider(const Text("Reply"), () {}),
                  _buttonProvider(const Icon(Icons.favorite_outline), () {})
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

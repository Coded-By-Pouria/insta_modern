import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final void Function(int index) onTap;
  final Map<String, int?> tabData;
  const CustomTabBar({
    super.key,
    required this.onTap,
    required this.tabData,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int _selectedIndex = 0;
  void selectItem(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      widget.onTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    final childList = <Widget>[];
    widget.tabData.forEach((label, value) {
      bool isSelected = index == _selectedIndex;
      childList.add(
        Padding(
          padding: const EdgeInsets.only(
            left: 5,
            right: 5,
            bottom: 5,
          ),
          child: ActivityButton(
            index: index++,
            label: label,
            onTap: selectItem,
            unchecedCounts: value,
            bgColor: isSelected ? Colors.black : Colors.white,
            textColor: isSelected ? Colors.white : Colors.black,
          ),
        ),
      );
    });

    return ElevatedButtonTheme(
      data: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0.0),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: childList,
        ),
      ),
    );
  }
}

class ActivityButton extends StatefulWidget {
  final int? unchecedCounts;
  final String label;
  final int index;
  final void Function(int index) onTap;
  final Color bgColor;
  final Color textColor;

  const ActivityButton({
    super.key,
    required this.label,
    required this.index,
    required this.onTap,
    required this.textColor,
    required this.bgColor,
    this.unchecedCounts,
  });

  @override
  State<ActivityButton> createState() => _ActivityButtonState();
}

class _ActivityButtonState extends State<ActivityButton> {
  final GlobalKey<State> _gk = GlobalKey();
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ElevatedButton(
          key: _gk,
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              widget.textColor,
            ),
            backgroundColor: MaterialStateProperty.all(
              widget.bgColor,
            ),
          ),
          onPressed: () {
            final i = widget.index;
            setState(() {
              _isChecked = true;
            });
            widget.onTap(i);
          },
          child: Text(
            widget.label,
          ),
        ),
        if (!_isChecked && widget.unchecedCounts != null)
          Positioned.fill(
            top: -10,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.redAccent,
                ),
                child: Text(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  widget.unchecedCounts.toString(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

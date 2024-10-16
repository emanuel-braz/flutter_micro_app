import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final ValueChanged<int>? onTap;
  final Duration sideBarAnimationDuration;
  final Duration floatingAnimationDuration;
  final double widthSwitch;
  final double borderRadius;
  final double sideBarWidth;
  final double sideBarSmallWidth;
  final List<CustomDrawerItem> sidebarItems;
  final bool settingsDivider;
  final Curve curve;
  final TextStyle textStyle;
  final ScrollPhysics scrollPhysics;

  const CustomDrawer({
    super.key,
    this.borderRadius = 20,
    this.sideBarWidth = 260,
    this.sideBarSmallWidth = 84,
    this.settingsDivider = true,
    this.curve = Curves.easeOut,
    this.sideBarAnimationDuration = const Duration(milliseconds: 700),
    this.floatingAnimationDuration = const Duration(milliseconds: 500),
    this.textStyle =
        const TextStyle(fontFamily: "SFPro", fontSize: 16, color: Colors.white),
    required this.sidebarItems,
    required this.widthSwitch,
    required this.onTap,
    this.scrollPhysics = const BouncingScrollPhysics(),
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late double _width;
  late double _height;
  late double sideBarItemHeight = 48;
  double _itemIndex = 0.0;
  bool _minimize = false;
  late Timer _counterTimer;

  @override
  void initState() {
    if (widget.sidebarItems.isEmpty) {
      throw "Side bar Items can't be empty";
    }

    _counterTimer =
        Timer.periodic(const Duration(minutes: 10000), (Timer timer) {});
    _counterTimer.cancel();
    super.initState();
  }

  @override
  void dispose() {
    _counterTimer.cancel();
    super.dispose();
  }

  void moveToNewIndex(int index) {
    setState(() {
      _counterTimer.cancel();
    });

    setState(() {
      _itemIndex = index.toDouble();
      _counterTimer.cancel();
    });
    widget.onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.sizeOf(context).height;
    _width = MediaQuery.sizeOf(context).width;

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      curve: widget.curve,
      height: _height,
      margin: const EdgeInsets.all(20),
      width: _width >= widget.widthSwitch && !_minimize
          ? widget.sideBarWidth
          : widget.sideBarSmallWidth,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : theme.secondaryHeaderColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      duration: widget.sideBarAnimationDuration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: widget.scrollPhysics,
              padding: EdgeInsets.only(
                  top: 40,
                  left: _width >= widget.widthSwitch && !_minimize ? 20 : 18,
                  right: _width >= widget.widthSwitch && !_minimize ? 20 : 18,
                  bottom: 24),
              child: Column(
                children: [
                  SizedBox(
                    height: 786.0,
                    child: Stack(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _getBarItem(
                                textStyle: widget.textStyle,
                                unselectedIconColor: isDarkMode
                                    ? Colors.white.withOpacity(0.9)
                                    : Colors.grey[800]!,
                                unSelectedTextColor: isDarkMode
                                    ? Colors.white.withOpacity(0.9)
                                    : Colors.grey[800]!,
                                widthSwitch: widget.widthSwitch,
                                minimize: _minimize,
                                height: sideBarItemHeight,
                                hoverColor: theme.hoverColor,
                                splashColor: theme.hoverColor,
                                highlightColor: theme.hoverColor,
                                width: _width,
                                icon:
                                    widget.sidebarItems[index].iconUnselected ??
                                        widget.sidebarItems[index].iconSelected,
                                text: widget.sidebarItems[index].text,
                                onTap: () => moveToNewIndex(index));
                          },
                          separatorBuilder: (context, index) {
                            if (index == widget.sidebarItems.length - 2 &&
                                widget.settingsDivider) {
                              return Divider(
                                height: 12,
                                thickness: 0.2,
                                color: theme.dividerColor,
                              );
                            } else {
                              return const SizedBox(
                                height: 8,
                              );
                            }
                          },
                          itemCount: widget.sidebarItems.length,
                        ),
                        AnimatedAlign(
                          alignment: Alignment(0, -1 - (-0.152 * _itemIndex)),
                          duration: widget.floatingAnimationDuration,
                          curve: widget.curve,
                          child: Container(
                            height: sideBarItemHeight,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: theme.canvasColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: ListView(
                              shrinkWrap: false,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              scrollDirection: Axis.horizontal,
                              children: [
                                Icon(
                                  widget.sidebarItems[_itemIndex.floor()]
                                      .iconSelected,
                                  color: isDarkMode
                                      ? Colors.white
                                      : theme.primaryColor,
                                ),
                                if (_width >= widget.widthSwitch && !_minimize)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      widget.sidebarItems[_itemIndex.floor()]
                                          .text,
                                      overflow: TextOverflow.ellipsis,
                                      style: widget.textStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode
                                              ? Colors.white
                                              : theme.primaryColor),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_width >= widget.widthSwitch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: IconButton(
                  hoverColor: Colors.black38,
                  splashColor: Colors.black87,
                  highlightColor: Colors.black,
                  onPressed: () {
                    setState(() => _minimize = !_minimize);
                  },
                  icon: Icon(
                      _width >= widget.widthSwitch && _minimize
                          ? CupertinoIcons.arrow_right
                          : CupertinoIcons.arrow_left,
                      color: theme.primaryColor)),
            )
        ],
      ),
    );
  }

  Widget _getBarItem({
    required IconData icon,
    required String text,
    required double width,
    required double widthSwitch,
    required bool minimize,
    required double height,
    required Color hoverColor,
    required Color unselectedIconColor,
    required Color splashColor,
    required Color highlightColor,
    required Color unSelectedTextColor,
    required Function() onTap,
    required TextStyle textStyle,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: onTap,
        hoverColor: hoverColor,
        splashColor: splashColor,
        highlightColor: highlightColor,
        child: SizedBox(
          height: height,
          child: ListView(
            padding: const EdgeInsets.all(12),
            shrinkWrap: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            scrollDirection: Axis.horizontal,
            children: [
              Icon(
                icon,
                color: unselectedIconColor,
              ),
              if (width >= widthSwitch && !minimize)
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    text,
                    overflow: TextOverflow.clip,
                    style: textStyle.copyWith(color: unSelectedTextColor),
                    textAlign: TextAlign.left,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDrawerItem {
  final IconData iconSelected;
  final IconData? iconUnselected;
  final String text;

  CustomDrawerItem({
    required this.iconSelected,
    this.iconUnselected,
    required this.text,
  });
}

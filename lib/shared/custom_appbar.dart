import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.elevation = 0,
    this.leadingWidth,
    this.centerTitle,
    this.titleSpacing,
    this.actions,
  });
  final Widget? leading;
  final Widget? title;
  final double elevation;
  final double? titleSpacing;
  final double? leadingWidth;
  final List<Widget>? actions;
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      // backgroundColor: Theme.of(context).colorScheme.background,
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF131826),
        statusBarColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFF131826),
        statusBarIconBrightness: Theme.of(context).brightness,
        statusBarBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarIconBrightness: Theme.of(context).brightness,
      ),
      elevation: elevation,
      titleSpacing: titleSpacing,
      leadingWidth: leadingWidth,
      leading: leading,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

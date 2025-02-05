import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double titleSize;
  final bool isBackButton;
  final bool isSettingButton;
  const AppBarWidget(
      {super.key,
      required this.title,
      required this.titleSize,
      required this.isBackButton,
      required this.isSettingButton});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: titleSize,
          ),
        ),
      ),
      leading: isBackButton
          ? Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 10,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      // actions: [
      //   if (isSettingButton)
      //     Padding(
      //       padding: const EdgeInsets.only(top: 7.0, right: 8.0),
      //       child: IconButton(
      //           onPressed: () {
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => const SettingPage()));
      //           },
      //           icon: const Icon(Icons.settings)),
      //     )
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
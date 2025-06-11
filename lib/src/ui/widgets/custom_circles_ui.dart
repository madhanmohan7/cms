import 'package:flutter/material.dart';

import '../../utils/colors/colors.dart';

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Transform.translate(
            offset: const Offset(25, -35),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: oBlack.withOpacity(.05),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Transform.translate(
            offset: const Offset(-70, 50),
            child: CircleAvatar(
              radius: 80,
              backgroundColor: oBlack.withOpacity(.05),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

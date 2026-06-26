import 'package:flutter/material.dart';

import '../constants.dart';
import '../theme/color.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    Key? key,
    this.isActive = false,
    this.activeColor = primary,
    this.inActiveColor = const Color(0xFF868686),
  }) : super(key: key);

  final bool isActive;
  final Color activeColor, inActiveColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kDefaultDuration,
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
      height: 5,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inActiveColor.withOpacity(0.25),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../theme/color.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final GestureTapCallback press;

  const PrimaryButton({Key? key, required this.text, required this.press})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    EdgeInsets verticalPadding =
        const EdgeInsets.symmetric(vertical: defaultPadding);
    return SizedBox(
      width: double.infinity,
      child: Platform.isIOS
          ? CupertinoButton(
              padding: verticalPadding,
              color: primary,
              onPressed: press,
              child: buildText(context),
            )
          : ElevatedButton(
              style: TextButton.styleFrom(
                padding: verticalPadding,
                backgroundColor: primary,
              ),
              onPressed: press,
              child: buildText(context),
            ),
    );
  }

  Text buildText(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: kButtonTextStyle,
    );
  }
}

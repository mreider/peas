import 'package:flutter/material.dart';

import '../config/colors.dart';

class CustomSurffixIcon extends StatelessWidget {
  const CustomSurffixIcon({
    required this.svgIcon,
    required this.size,
  });

  final String svgIcon;
  final int size;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kColorPrimary,
          border: Border.all(color: kColorPrimary, width: 2),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              svgIcon,
            ),
          )),
    );
  }
}

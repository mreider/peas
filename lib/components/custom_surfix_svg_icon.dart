import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class CustomSvgIcon extends StatelessWidget {
  const CustomSvgIcon({
    Key? key,
    required this.svgIcon,
  }) : super(key: key);

  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0, 5, 20, 20,
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: 35,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utlis/assest_path.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          AssetPath.backgroundSvg,
          fit: BoxFit.cover,
          width:MediaQuery.of(context).size.width,
          height:MediaQuery.of(context).size.height,
        ),
        SafeArea(child: child),
      ],
    );
  }
}

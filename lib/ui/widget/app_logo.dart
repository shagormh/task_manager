import 'package:flutter/material.dart';
import '../utlis/assest_path.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(AssetPath.logoSvg,width: 120,);
  }
}
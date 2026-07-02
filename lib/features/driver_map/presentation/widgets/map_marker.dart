import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapMarker extends StatelessWidget {
  final String svgAsset;
  final double width;
  final double height;
  final Alignment alignment;

  const MapMarker({
    super.key,
    required this.svgAsset,
    this.width = 90,
    this.height = 24,
    this.alignment = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SvgPicture.asset(
        svgAsset,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}

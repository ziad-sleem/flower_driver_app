import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracking_app/core/resources/app_svgs.dart';

enum MapMarkerKind { driver, store, user }

/// Returns the exact [width] and [height] the flutter_map [Marker] should use
/// for [kind], and the correct [alignment] to pin the icon to its geo point.
MapMarkerDimensions mapMarkerDimensions(MapMarkerKind kind) {
  switch (kind) {
    case MapMarkerKind.driver:
      // badge: 90×20 natural ratio; display at height=32
      return const MapMarkerDimensions(
        width: 104,
        height: 32,
        alignment: Alignment.center,
      );
    case MapMarkerKind.store:
      // badge: 56×20 natural ratio; display at height=26
      return const MapMarkerDimensions(
        width: 72,
        height: 26,
        alignment: Alignment.center,
      );
    case MapMarkerKind.user:
      // badge: 44×24 with needle at bottom centre; display at height=30
      return const MapMarkerDimensions(
        width: 56,
        height: 30,
        alignment: Alignment.bottomCenter,
      );
  }
}

class MapMarkerDimensions {
  final double width;
  final double height;
  final Alignment alignment;
  const MapMarkerDimensions({
    required this.width,
    required this.height,
    required this.alignment,
  });
}

class MapMarker extends StatefulWidget {
  const MapMarker({
    super.key,
    required this.kind,
    this.size = 72,
    this.showPulse = false,
  });

  final MapMarkerKind kind;
  final double size;
  final bool showPulse;

  @override
  State<MapMarker> createState() => _MapMarkerState();
}

class _MapMarkerState extends State<MapMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );

    if (widget.showPulse) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant MapMarker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showPulse && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.showPulse && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _MarkerStyle _style(MapMarkerKind kind) {
    switch (kind) {
      case MapMarkerKind.driver:
        return const _MarkerStyle(
          color: Color(0xFF4CAF50),
          asset: AppSvgs.myLocation,
        );

      case MapMarkerKind.store:
        return const _MarkerStyle(
          color: Color(0xFFD21E6A),
          asset: AppSvgs.floweryLocation,
        );

      case MapMarkerKind.user:
        return const _MarkerStyle(
          color: Color(0xFF2196F3),
          asset: AppSvgs.userLocation,
          hasBuiltInNeedle: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style(widget.kind);
    final dims = mapMarkerDimensions(widget.kind);

    // The SVGs are landscape badge/pill shapes. Render them at their natural
    // aspect ratio so they fill the allotted width without getting squished.
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Pulse ring: circular, centred on the icon
        if (widget.showPulse)
          AnimatedBuilder(
            animation: CurvedAnimation(
              parent: _controller,
              curve: Curves.easeOut,
            ),
            builder: (context, child) {
              final value = _controller.value;
              final pulseSize = dims.height * 0.9;
              return Transform.scale(
                scale: 1 + value * 0.8,
                child: Opacity(
                  opacity: (1 - value) * 0.4,
                  child: Container(
                    width: pulseSize,
                    height: pulseSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: style.color,
                    ),
                  ),
                ),
              );
            },
          ),

        // The badge SVG at its natural aspect ratio
        SvgPicture.asset(
          style.asset,
          width: dims.width,
          height: dims.height,
          fit: BoxFit.fill,
        ),
      ],
    );
  }
}

class _MarkerStyle {
  final Color color;
  final String asset;
  final bool hasBuiltInNeedle;

  const _MarkerStyle({
    required this.color,
    required this.asset,
    this.hasBuiltInNeedle = false,
  });
}

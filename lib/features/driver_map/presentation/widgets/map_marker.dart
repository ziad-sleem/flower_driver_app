import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum MapMarkerKind { driver, store, user }

class MapMarker extends StatefulWidget {
  final MapMarkerKind kind;
  final double size;
  final bool showPulse;

  const MapMarker({
    super.key,
    required this.kind,
    this.size = 52,
    this.showPulse = false,
  });

  @override
  State<MapMarker> createState() => _MapMarkerState();
}

class _MapMarkerState extends State<MapMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    if (widget.showPulse) {
      _pulseController.repeat();
    }
  }

  @override
  void didUpdateWidget(MapMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showPulse && !_pulseController.isAnimating) {
      _pulseController.repeat();
    } else if (!widget.showPulse && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.value = 0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  _MarkerStyle _styleFor(MapMarkerKind kind) {
    switch (kind) {
      case MapMarkerKind.driver:
        return const _MarkerStyle(
          color: Color(0xFF4CAF50),
          assetPath: 'assets/svgs/my_location.svg',
        );
      case MapMarkerKind.store:
        return const _MarkerStyle(
          color: Color(0xFFD21E6A),
          assetPath: 'assets/svgs/flowery_location.svg',
        );
      case MapMarkerKind.user:
        return const _MarkerStyle(
          color: Color(0xFF2196F3),
          assetPath: 'assets/svgs/user_location.svg',
          hasBuiltInNeedle: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(widget.kind);
    final badgeHeight = widget.size.clamp(28.0, 48.0);
    final needleHeight = badgeHeight * 0.45;
    final needleWidth = badgeHeight * 0.25;
    final shadowHeight = badgeHeight * 0.12;
    final totalHeight = style.hasBuiltInNeedle
        ? badgeHeight + 2
        : badgeHeight + needleHeight + shadowHeight + 2;

    return SizedBox(
      width: badgeHeight * 3.5,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          if (widget.showPulse)
            Positioned(
              top: badgeHeight / 2 - 16,
              left: (badgeHeight * 3.5 - 32) / 2,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final pulseScale = 1 + (_pulseController.value * 0.6);
                  final opacity = (1 - _pulseController.value) * 0.35;
                  return Transform.scale(
                    scale: pulseScale,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: style.color.withValues(alpha: opacity),
                      ),
                    ),
                  );
                },
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              style.assetPath,
              height: badgeHeight,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(style.color, BlendMode.srcIn),
            ),
          ),
          if (!style.hasBuiltInNeedle) ...[
            Positioned(
              top: badgeHeight - 1,
              left: (badgeHeight * 3.5 - needleWidth) / 2,
              child: CustomPaint(
                size: Size(needleWidth, needleHeight),
                painter: _PinNeedlePainter(color: style.color),
              ),
            ),
            Positioned(
              top: badgeHeight + needleHeight - 1,
              left: (badgeHeight * 3.5 - badgeHeight * 0.35) / 2,
              child: Container(
                width: badgeHeight * 0.35,
                height: shadowHeight,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MarkerStyle {
  final Color color;
  final String assetPath;
  final bool hasBuiltInNeedle;

  const _MarkerStyle({
    required this.color,
    required this.assetPath,
    this.hasBuiltInNeedle = false,
  });
}

class _PinNeedlePainter extends CustomPainter {
  final Color color;

  const _PinNeedlePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color,
          color.withValues(alpha: 0.85),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PinNeedlePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

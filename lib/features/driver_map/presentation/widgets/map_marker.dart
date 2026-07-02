import 'package:flutter/material.dart';

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
          lightColor: Color(0xFF81C784),
          icon: Icons.navigation_rounded,
          label: 'You',
        );
      case MapMarkerKind.store:
        return const _MarkerStyle(
          color: Color(0xFFD21E6A),
          lightColor: Color(0xFFE98FB5),
          icon: Icons.local_florist_rounded,
          label: 'Store',
        );
      case MapMarkerKind.user:
        return const _MarkerStyle(
          color: Color(0xFF2196F3),
          lightColor: Color(0xFF64B5F6),
          icon: Icons.home_rounded,
          label: 'Customer',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(widget.kind);
    final headSize = widget.size.clamp(36.0, 72.0);
    final iconSize = headSize * 0.38;
    final needleHeight = headSize * 0.24;
    final needleWidth = headSize * 0.2;
    final labelFontSize = (headSize * 0.19).clamp(10.0, 14.0);
    final labelHeight = labelFontSize * 1.1 + headSize * 0.1;
    final shadowHeight = headSize * 0.08;
    final totalWidth = headSize * 1.6;
    final totalHeight =
        labelHeight + headSize + needleHeight + shadowHeight + 4;

    final headTop = labelHeight;
    final needleTop = headTop + headSize - 2;
    final shadowTop = needleTop + needleHeight;

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          if (widget.showPulse)
            Positioned(
              top: headTop,
              left: (totalWidth - headSize) / 2,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = 1 + (_pulseController.value * 0.45);
                  final opacity = (1 - _pulseController.value) * 0.3;
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: headSize,
                      height: headSize,
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
            height: labelHeight,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: headSize * 0.14,
                  vertical: headSize * 0.05,
                ),
                decoration: BoxDecoration(
                  color: style.color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  style.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: headTop,
            left: (totalWidth - headSize) / 2,
            child: Container(
              width: headSize,
              height: headSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    style.lightColor.withValues(alpha: 0.15),
                  ],
                ),
                border: Border.all(color: style.color, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: style.color.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                style.icon,
                color: style.color,
                size: iconSize,
              ),
            ),
          ),
          Positioned(
            top: needleTop,
            left: (totalWidth - needleWidth) / 2,
            child: CustomPaint(
              size: Size(needleWidth, needleHeight),
              painter: _PinNeedlePainter(color: style.color),
            ),
          ),
          Positioned(
            top: shadowTop,
            left: (totalWidth - headSize * 0.35) / 2,
            child: Container(
              width: headSize * 0.35,
              height: shadowHeight,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarkerStyle {
  final Color color;
  final Color lightColor;
  final IconData icon;
  final String label;

  const _MarkerStyle({
    required this.color,
    required this.lightColor,
    required this.icon,
    required this.label,
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

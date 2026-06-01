import 'package:flutter/material.dart';
export 'grid_painter.dart';

class WashiTape extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final double rotation;

  const WashiTape({
    super.key,
    this.color = const Color(0xFFB8D4C8),
    this.width = 80,
    this.height = 20,
    this.rotation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class StickyCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool showTape;

  const StickyCard({
    super.key,
    required this.child,
    this.color = const Color(0xFFF5C842),
    this.showTape = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        if (showTape)
          Positioned(
            top: -12,
            child: WashiTape(width: 70, height: 22),
          ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class DotNavigation extends StatelessWidget {
  final int slideCount;
  final int currentIndex;
  final ValueChanged<int> onDotTapped;

  const DotNavigation({
    super.key,
    required this.slideCount,
    required this.currentIndex,
    required this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(slideCount, (index) {
          final isActive = index == currentIndex;
          return GestureDetector(
            onTap: () => onDotTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(vertical: 5),
              width: isActive ? 12 : 8,
              height: isActive ? 12 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.black : Colors.black38,
              ),
            ),
          );
        }),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';

/// Provides the active/visible state of the current section to descendant
/// [Reveal] widgets. When [active] flips to true, reveals play their animation.
class RevealScope extends InheritedWidget {
  final bool active;
  const RevealScope({super.key, required this.active, required super.child});

  static bool of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<RevealScope>();
    return scope?.active ?? true;
  }

  @override
  bool updateShouldNotify(RevealScope old) => old.active != active;
}

/// Fades + slides its child in while the enclosing [RevealScope] is active,
/// and clears it back out (reverse animation) when the scope turns inactive —
/// so content re-animates each time you enter/leave the section.
/// Use [delayMs] to stagger sibling reveals.
class Reveal extends StatefulWidget {
  final Widget child;
  final int delayMs;
  final Offset beginOffset;

  const Reveal({
    super.key,
    required this.child,
    this.delayMs = 0,
    this.beginOffset = const Offset(0, 0.14),
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  );
  late final Animation<double> _fade =
      CurvedAnimation(parent: _c, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: widget.beginOffset,
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));

  Timer? _timer;
  bool? _wasActive;

  // Play forward when the section becomes active, reverse out when it leaves.
  // The stagger delay applies in both directions.
  void _apply() {
    final active = RevealScope.of(context);
    if (active == _wasActive) return;
    _wasActive = active;
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: widget.delayMs), () {
      if (!mounted) return;
      if (active) {
        _c.forward();
      } else {
        _c.reverse();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apply();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

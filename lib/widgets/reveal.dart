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

/// Fades + slides its child in once the enclosing [RevealScope] becomes active.
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
  bool _played = false;

  void _maybePlay() {
    if (_played || !RevealScope.of(context)) return;
    _played = true;
    _timer = Timer(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybePlay();
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

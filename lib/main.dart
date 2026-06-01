import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/slide_model.dart';
import 'widgets/dot_navigation.dart';
import 'slides/cover_slide.dart';
import 'slides/problem_slide.dart';
import 'slides/why_now_slide.dart';
import 'slides/solution_slide.dart';
import 'slides/prototype_slide.dart';
import 'slides/insights_slide.dart';
import 'slides/impact_slide.dart';
import 'slides/team_slide.dart';
import 'services/export_service.dart';

void main() {
  runApp(const PitchDeckApp());
}

class PitchDeckApp extends StatelessWidget {
  const PitchDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pitch Deck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const PitchDeckHome(),
    );
  }
}

class PitchDeckHome extends StatefulWidget {
  const PitchDeckHome({super.key});

  @override
  State<PitchDeckHome> createState() => _PitchDeckHomeState();
}

class _PitchDeckHomeState extends State<PitchDeckHome> {
  int _currentSlide = 0;
  bool _isExporting = false;

  late final List<SlideModel> _slides;
  late final List<GlobalKey> _slideKeys;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _slides = [
      SlideModel(id: 'cover', label: 'Cover', builder: (_) => const CoverSlide()),
      SlideModel(id: 'problem', label: 'Problem', builder: (_) => const ProblemSlide()),
      SlideModel(id: 'why_now', label: 'Why Now', builder: (_) => const WhyNowSlide()),
      SlideModel(id: 'solution', label: 'Solution', builder: (_) => const SolutionSlide()),
      SlideModel(id: 'prototype', label: 'Prototype', builder: (_) => const PrototypeSlide()),
      SlideModel(id: 'insights', label: 'Insights', builder: (_) => const InsightsSlide()),
      SlideModel(id: 'impact', label: 'Impact', builder: (_) => const ImpactSlide()),
      SlideModel(id: 'team', label: 'Team', builder: (_) => const TeamSlide()),
    ];
    _slideKeys = List.generate(_slides.length, (_) => GlobalKey());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    setState(() => _currentSlide = index.clamp(0, _slides.length - 1));
  }

  void _handleKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.space) {
        _goTo(_currentSlide + 1);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _goTo(_currentSlide - 1);
      }
    }
  }

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);
    final savedSlide = _currentSlide;
    try {
      final images = <Uint8List>[];
      for (int i = 0; i < _slides.length; i++) {
        setState(() => _currentSlide = i);
        await Future.delayed(const Duration(milliseconds: 400));
        final bytes = await ExportService.captureSlide(_slideKeys[i]);
        if (bytes != null) images.add(bytes);
      }
      setState(() => _currentSlide = savedSlide);
      if (images.isNotEmpty) {
        await ExportService.exportToPdf(images);
      }
    } finally {
      setState(() {
        _isExporting = false;
        _currentSlide = savedSlide;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode..requestFocus(),
      onKeyEvent: _handleKey,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Slide area
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _goTo(_currentSlide + 1),
                child: RepaintBoundary(
                  key: _slideKeys[_currentSlide],
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: SizedBox.expand(
                      key: ValueKey(_currentSlide),
                      child: _slides[_currentSlide].builder(context),
                    ),
                  ),
                ),
              ),
            ),

            // Top toolbar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _Toolbar(
                currentSlide: _currentSlide,
                totalSlides: _slides.length,
                slideLabel: _slides[_currentSlide].label,
                isExporting: _isExporting,
                onPrev: () => _goTo(_currentSlide - 1),
                onNext: () => _goTo(_currentSlide + 1),
                onExport: _exportPdf,
              ),
            ),

            // Right side dot navigation
            Positioned(
              right: 20,
              top: 48,
              bottom: 0,
              child: Center(
                child: DotNavigation(
                  slideCount: _slides.length,
                  currentIndex: _currentSlide,
                  onDotTapped: _goTo,
                ),
              ),
            ),

            // Aspect ratio indicator — must be a Positioned direct Stack child
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _AspectRatioGuard(),
            ),

            // Export progress overlay
            if (_isExporting)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.65),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 16),
                        Text(
                          'Capturing slides for PDF export...',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final int currentSlide;
  final int totalSlides;
  final String slideLabel;
  final bool isExporting;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onExport;

  const _Toolbar({
    required this.currentSlide,
    required this.totalSlides,
    required this.slideLabel,
    required this.isExporting,
    required this.onPrev,
    required this.onNext,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: Colors.black.withValues(alpha: 0.88),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            'PITCH DECK',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          Text(
            '$slideLabel  •  ${currentSlide + 1} / $totalSlides',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(width: 20),
          _navBtn(Icons.arrow_back_ios_new, onPrev, currentSlide == 0),
          const SizedBox(width: 4),
          _navBtn(Icons.arrow_forward_ios, onNext, currentSlide == totalSlides - 1),
          const SizedBox(width: 12),
          TextButton.icon(
            onPressed: isExporting ? null : onExport,
            icon: const Icon(Icons.picture_as_pdf, size: 16, color: Color(0xFFF5C842)),
            label: const Text(
              'Export PDF',
              style: TextStyle(color: Color(0xFFF5C842), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap, bool disabled) {
    return IconButton(
      onPressed: disabled ? null : onTap,
      icon: Icon(icon, size: 14, color: disabled ? Colors.white24 : Colors.white70),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
    );
  }
}

// ── Aspect ratio guard ──────────────────────────────────────────────────────

class _AspectRatioGuard extends StatelessWidget {
  const _AspectRatioGuard();

  static const _target = 16.0 / 9.0;
  static const _tolerance = 0.04; // ±4%

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final ratio = size.width / size.height;
    final delta = ((ratio - _target) / _target).abs();

    if (delta <= _tolerance) return const SizedBox.shrink();

    return _Banner(
      isTooWide: ratio > _target,
      pct: (delta * 100).toStringAsFixed(0),
      ratio: ratio,
    );
  }
}

class _Banner extends StatefulWidget {
  final bool isTooWide;
  final String pct;
  final double ratio;
  const _Banner({required this.isTooWide, required this.pct, required this.ratio});

  @override
  State<_Banner> createState() => _BannerState();
}

class _BannerState extends State<_Banner> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(_anim),
      child: Container(
        color: const Color(0xFFF5C842),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.aspect_ratio, size: 18, color: Colors.black),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.isTooWide
                    ? 'Window is ${widget.pct}% too wide for 16:9 — resize to match PowerPoint ratio'
                    : 'Window is ${widget.pct}% too tall for 16:9 — resize to match PowerPoint ratio',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Current ${widget.ratio.toStringAsFixed(2)}  ·  Target 1.78',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

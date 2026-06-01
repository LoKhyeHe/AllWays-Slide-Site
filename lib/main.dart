import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/slide_model.dart';
import 'widgets/reveal.dart';
import 'slides/cover_slide.dart';
import 'slides/problem_slide.dart';
import 'slides/why_now_slide.dart';
import 'slides/solution_slide.dart';
import 'slides/prototype_slide.dart';
import 'slides/insights_slide.dart';
import 'slides/impact_slide.dart';
import 'slides/team_slide.dart';
import 'slides/contact_slide.dart';
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
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  double _unitExtent = 1;
  final Set<int> _revealed = {0};

  static const double _navBarHeight = 60;
  static const double _mobileBreakpoint = 760;

  @override
  void initState() {
    super.initState();
    _slides = [
      SlideModel(id: 'cover', label: 'Home', builder: (_) => const CoverSlide()),
      SlideModel(id: 'problem', label: 'Problem', builder: (_) => const ProblemSlide()),
      SlideModel(id: 'why_now', label: 'Why Now', builder: (_) => const WhyNowSlide()),
      SlideModel(id: 'solution', label: 'Solution', builder: (_) => const SolutionSlide()),
      SlideModel(id: 'prototype', label: 'Prototype', builder: (_) => const PrototypeSlide()),
      SlideModel(id: 'insights', label: 'Insights', builder: (_) => const InsightsSlide()),
      SlideModel(id: 'impact', label: 'Impact', builder: (_) => const ImpactSlide()),
      SlideModel(id: 'team', label: 'Team', builder: (_) => const TeamSlide()),
      SlideModel(id: 'contact', label: 'Contact', builder: (_) => const ContactSlide()),
    ];
    _slideKeys = List.generate(_slides.length, (_) => GlobalKey());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Key-based detection so it works for both fixed-height (desktop) and
    // variable-height (mobile) sections. The current section is the last one
    // whose top has scrolled above a reference line near the top of the
    // viewport (just below the nav bar).
    final refY = _navBarHeight + _unitExtent * 0.4;
    int idx = 0;
    for (int i = 0; i < _slideKeys.length; i++) {
      final ctx = _slideKeys[i].currentContext;
      final box = ctx?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      final top = box.localToGlobal(Offset.zero).dy;
      if (top <= refY) idx = i;
    }
    if (idx != _currentSlide) {
      setState(() {
        _currentSlide = idx;
        _revealed.add(idx);
      });
    }
  }

  void _goTo(int index) {
    final i = index.clamp(0, _slides.length - 1);
    final ctx = _slideKeys[i].currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
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
    setState(() {
      _isExporting = true;
      _revealed.addAll(List.generate(_slides.length, (i) => i));
    });
    // Let any pending reveal animations settle before capturing.
    await Future.delayed(const Duration(milliseconds: 1000));
    try {
      final images = <Uint8List>[];
      for (final key in _slideKeys) {
        final bytes = await ExportService.captureSlide(key);
        if (bytes != null) images.add(bytes);
      }
      if (images.isNotEmpty) {
        await ExportService.exportToPdf(images);
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode..requestFocus(),
      onKeyEvent: _handleKey,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: Stack(
          children: [
            Column(
              children: [
                _NavBar(
                  items: const [
                    _NavItem('Home', 0),
                    _NavItem('Solution', 3),
                    _NavItem('Team', 7),
                    _NavItem('Contact', 8),
                  ],
                  currentIndex: _currentSlide,
                  isExporting: _isExporting,
                  onNavigate: _goTo,
                  onExport: _exportPdf,
                ),
                // Seamless full-bleed sections — each fills the viewport
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;
                      _unitExtent = h;
                      final isMobile = w < _mobileBreakpoint;
                      return SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            for (int i = 0; i < _slides.length; i++)
                              RepaintBoundary(
                                key: _slideKeys[i],
                                child: RevealScope(
                                  active: _revealed.contains(i),
                                  child: SizedBox(
                                    width: w,
                                    child: isMobile
                                        // Mobile: let sections grow taller than
                                        // the viewport so content stacks freely.
                                        ? ConstrainedBox(
                                            constraints:
                                                BoxConstraints(minHeight: h),
                                            child: _slides[i].builder(context),
                                          )
                                        // Desktop: each section fills exactly
                                        // one viewport.
                                        : SizedBox(
                                            height: h,
                                            child: _slides[i].builder(context),
                                          ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
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

class _NavItem {
  final String label;
  final int slideIndex;
  const _NavItem(this.label, this.slideIndex);
}

class _NavBar extends StatelessWidget {
  final List<_NavItem> items;
  final int currentIndex;
  final bool isExporting;
  final ValueChanged<int> onNavigate;
  final VoidCallback onExport;

  const _NavBar({
    required this.items,
    required this.currentIndex,
    required this.isExporting,
    required this.onNavigate,
    required this.onExport,
  });

  int get _activeSlideIndex {
    int active = items.first.slideIndex;
    for (final item in items) {
      if (currentIndex >= item.slideIndex) active = item.slideIndex;
    }
    return active;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 760;
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(color: Colors.white12, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 14 : 28),
      child: Row(
        children: [
          // Brand — scrolls to top
          InkWell(
            onTap: () => onNavigate(0),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'AllWays',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5C842),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: isMobile ? 12 : 28),
          // Section links — scroll horizontally if space is tight
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final item in items)
                    _NavLink(
                      label: item.label,
                      active: item.slideIndex == _activeSlideIndex,
                      onTap: () => onNavigate(item.slideIndex),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Export button — icon-only on mobile to save width
          Material(
            color: const Color(0xFFF5C842),
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: isExporting ? null : onExport,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10 : 16, vertical: 9),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.picture_as_pdf,
                        size: 16, color: Colors.black),
                    if (!isMobile) ...const [
                      SizedBox(width: 8),
                      Text(
                        'Export PDF',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavLink({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFFF5C842) : Colors.white70,
            fontSize: 13,
            fontWeight: active ? FontWeight.w800 : FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

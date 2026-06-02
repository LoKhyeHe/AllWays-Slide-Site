import 'package:flutter/material.dart';
import '../widgets/reveal.dart';
import '../widgets/media_carousel.dart';

class PrototypeSlide extends StatelessWidget {
  const PrototypeSlide({super.key});

  static const _features = [
    _Feature(Icons.vibration_outlined, 'Haptic Feedback',
        'Directional vibration cues — left, right, forward, stop — zero visual attention required.'),
    _Feature(Icons.router_outlined, 'UWB Positioning',
        'Ultra-wideband anchors triangulate position to within ~30 cm indoors.'),
    _Feature(Icons.hardware_outlined, 'Durable Belt Design',
        'PETG clip mechanism with universal loop attachment. Built for real-world wear.'),
    _Feature(Icons.phone_android_outlined, 'Low-Load Interface',
        'Large touch targets, simple destination selection. Validated with VI users.'),
  ];

  static const _carouselItems = [
    CarouselItem.video(
      'lib/images/sutd_proposal.mp4',
      title: 'Project Proposal Demo',
      name: 'AllWays Team',
      organisation: 'SUTD',
      action: 'Concept pitch & walkthrough',
    ),
    CarouselItem.image(
      'lib/images/techable_testing.jpeg',
      title: 'User Testing',
      name: 'VI participants',
      organisation: 'TechAble',
      action: 'Belt navigation trial',
    ),
    CarouselItem.image(
      'lib/images/belt_testing.jpeg',
      title: 'Belt Testing',
      name: 'AllWays Team',
      organisation: 'In-house',
      action: 'Durability & fit check',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 760;
    return Container(
      color: Colors.black,
      child: isMobile ? _mobile() : _desktop(),
    );
  }

  Widget _mobile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OUR PROTOTYPE',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 0.95,
              letterSpacing: -1.5,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 180,
              child: Reveal(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 9 / 19.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'lib/images/app_ui.jpeg',
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'VoiceOver UI/UX Compatible Design',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white38, fontSize: 11, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < _features.length; i++) ...[
            Reveal(delayMs: 80 + i * 70, child: _featureCard(_features[i])),
            if (i != _features.length - 1) const SizedBox(height: 10),
          ],
          const SizedBox(height: 16),
          Reveal(
            delayMs: 360,
            child: AspectRatio(
              aspectRatio: 16 / 13,
              child: const MediaCarousel(items: _carouselItems),
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktop() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'OUR PROTOTYPE',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w900,
                height: 0.95,
                letterSpacing: -1.5,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Left: App UI at iPhone 15 aspect ratio (9:19.5) ──
                  SizedBox(
                    width: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Reveal(
                          child: AspectRatio(
                          aspectRatio: 9 / 19.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'lib/images/app_ui.jpeg',
                              fit: BoxFit.cover,
                              alignment: Alignment(0, -1),
                            ),
                          ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'VoiceOver UI/UX\nCompatible Design',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38, fontSize: 11, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // ── Right: feature cards + photo strip ────────────────
                  Expanded(
                    child: Column(
                      children: [
                        // 2×2 feature cards
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(child: Reveal(delayMs: 80, child: _featureCard(_features[0]))),
                                    const SizedBox(width: 10),
                                    Expanded(child: Reveal(delayMs: 160, child: _featureCard(_features[1]))),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(child: Reveal(delayMs: 240, child: _featureCard(_features[2]))),
                                    const SizedBox(width: 10),
                                    Expanded(child: Reveal(delayMs: 320, child: _featureCard(_features[3]))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // In-house testing carousel (video + photos)
                        Expanded(
                          flex: 4,
                          child: Reveal(
                            delayMs: 360,
                            child:
                                const MediaCarousel(items: _carouselItems),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Widget _featureCard(_Feature f) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(f.icon, color: const Color(0xFFF5C842), size: 18),
          const SizedBox(height: 8),
          Text(
            f.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            f.description,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;
  const _Feature(this.icon, this.title, this.description);
}

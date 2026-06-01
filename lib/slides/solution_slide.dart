import 'package:flutter/material.dart';
import '../widgets/washi_tape.dart';
import '../widgets/reveal.dart';

class SolutionSlide extends StatelessWidget {
  const SolutionSlide({super.key});

  static const _arrowW = 48.0;

  static const _steps = [
    _Step(
      number: '01',
      label: 'PICK UP',
      title: 'Accessible Collection Point',
      detail: 'Accessible placement of collection point allows visually impaired users to locate and pick up the device independently upon entry.',
      imagePath: 'lib/images/solution_pickup.jpg',
    ),
    _Step(
      number: '02',
      label: 'SELECT DESTINATION',
      title: 'Intuitive Mobile App',
      detail: 'A low-cognitive-load interface tested and validated with visually impaired users — simple, large targets, no clutter.',
      imagePath: 'lib/images/solution_app.jpg',
    ),
    _Step(
      number: '03',
      label: 'NAVIGATE',
      title: 'Live UWB Navigation',
      detail: 'Real-time positioning from UWB anchors and map data drives the haptic belt — guiding every step without visual cues.',
      imagePath: 'lib/images/solution_navigate.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          CustomPaint(painter: GridPainter(), size: Size.infinite),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'OUR SOLUTION',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    height: 0.95,
                    letterSpacing: -1.5,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                // ── Images — full column width, arrows between ─────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Reveal(delayMs: 0, child: _image(_steps[0]))),
                    _arrow(),
                    Expanded(child: Reveal(delayMs: 110, child: _image(_steps[1]))),
                    _arrow(),
                    Expanded(child: Reveal(delayMs: 220, child: _image(_steps[2]))),
                  ],
                ),
                const SizedBox(height: 12),
                // ── Cards — aligned under each image ──────────────────
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: Reveal(delayMs: 160, child: _card(_steps[0]))),
                      const SizedBox(width: _arrowW),
                      Expanded(child: Reveal(delayMs: 270, child: _card(_steps[1]))),
                      const SizedBox(width: _arrowW),
                      Expanded(child: Reveal(delayMs: 380, child: _card(_steps[2]))),
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

  Widget _image(_Step s) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        s.imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 340,
      ),
    );
  }

  Widget _arrow() {
    return SizedBox(
      width: _arrowW,
      child: Center(
        child: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFFF5C842),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _card(_Step s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                s.number,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFF5C842),
                  height: 1,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  s.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            s.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              s.detail,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Step {
  final String number;
  final String label;
  final String title;
  final String detail;
  final String imagePath;
  const _Step({
    required this.number,
    required this.label,
    required this.title,
    required this.detail,
    required this.imagePath,
  });
}

import 'package:flutter/material.dart';
import '../widgets/washi_tape.dart';

class ProblemSlide extends StatelessWidget {
  const ProblemSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          CustomPaint(painter: GridPainter(), size: Size.infinite),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Two columns — both vertically centred ──────────────
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left — title pinned just above the image, all centred as a group
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'THE PROBLEM',
                              style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                height: 0.95,
                                letterSpacing: -1.5,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Image.asset(
                                    'lib/images/school_visit.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'User testing with Hafiz and Zhi Yin\n— Singapore Association of the Visually Handicapped',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black38,
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 36),
                      // Right — HMW + context, vertically centred
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // White HMW card
                            Container(
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.black, width: 2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: const Text(
                                      'HOW MIGHT WE',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    'Empower visually impaired individuals to navigate any indoor space self-reliantly — with a system intuitive enough to use immediately, and reliable enough to trust completely?',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            // Yellow context card
                            StickyCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Indoor spaces are designed to be accessible — but not independently navigable.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  _row(Icons.map_outlined,
                                      'Complex layouts offer no spatial cues for those who cannot read signs or directories.'),
                                  const SizedBox(height: 10),
                                  _row(Icons.gps_off_outlined,
                                      'GPS signals don\'t penetrate buildings — indoor positioning remains an unsolved gap.'),
                                  const SizedBox(height: 10),
                                  _row(Icons.support_agent_outlined,
                                      'Users depend on staff or companions — surrendering the independence they deserve.'),
                                  const SizedBox(height: 10),
                                  _row(Icons.elderly_outlined,
                                      'As Singapore ages, the number of people affected will only grow.'),
                                  const SizedBox(height: 14),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.black.withValues(alpha: 0.07),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      '"Getting into the building is one thing. Finding where I need to go inside is another."',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black87,
                                          height: 1.5),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 13, color: Colors.black87, height: 1.4)),
        ),
      ],
    );
  }
}

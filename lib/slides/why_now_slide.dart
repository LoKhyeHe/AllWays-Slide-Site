import 'package:flutter/material.dart';
import '../widgets/washi_tape.dart';
import '../widgets/editable_image.dart';

class WhyNowSlide extends StatelessWidget {
  const WhyNowSlide({super.key});

  static const _stats = [
    _Stat(
      stat: '1 in 4',
      title: 'Ageing Singapore',
      body: 'Singapore citizens are expected to be aged 65+ by 2030, heightening the need for accessible indoor mobility solutions.',
      source: 'Population.gov.sg, 2024',
    ),
    _Stat(
      stat: '#1',
      title: 'Top Disability Type',
      body: 'Visual impairment is one of the most prevalent disability types in Singapore\'s disability landscape.',
      source: 'MSF Disability Trends Report, 2024',
    ),
    _Stat(
      stat: 'None',
      title: 'Outdoor GPS Can\'t Navigate Indoors',
      body: 'FairPrice is trialling GPS-tracked shopping carts — but visually impaired users cannot use them. No accessible indoor solution exists.',
      source: 'FairPrice Smart Store pilot',
    ),
    _Stat(
      stat: 'Today',
      title: 'The Window Is Open',
      body: 'UWB is proven in robotics and asset tracking. Accessibility design will become an infrastructure expectation.',
      source: 'Industry trend',
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
            padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'WHY NOW?',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    height: 0.95,
                    letterSpacing: -1.5,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left 1/3: photo
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          EditableImage(
                            configKey: 'why_now_bus',
                            assetPath: 'lib/images/KwekBin Bus.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Kwek Bin navigating a bus terminal — a daily challenge for the visually impaired.',
                            style: TextStyle(fontSize: 10, color: Colors.black38, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 28),
                    // Right 2/3: 4 stat cards
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: _stats
                            .expand((s) => [
                                  _statCard(s),
                                  if (s != _stats.last) const SizedBox(height: 10),
                                ])
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(_Stat s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5C842),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 92,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      s.stat,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: Colors.black.withValues(alpha: 0.2),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    s.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.body,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.source,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.black.withValues(alpha: 0.4),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat {
  final String stat;
  final String title;
  final String body;
  final String source;
  const _Stat({
    required this.stat,
    required this.title,
    required this.body,
    required this.source,
  });
}

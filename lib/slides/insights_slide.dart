import 'package:flutter/material.dart';
import '../widgets/washi_tape.dart';
import '../widgets/reveal.dart';

class InsightsSlide extends StatelessWidget {
  const InsightsSlide({super.key});

  static const _quotes = [
    _Quote(
      name: 'Ashokkumar',
      role: 'Therapist Head, AWWA',
      logoPath: 'lib/images/Logo/awwa.png',
      text: '"We can see strong applications in a school setting. We\'d be keen to collaborate on a pilot."',
    ),
    _Quote(
      name: 'Kwek Bin',
      role: 'Tech Analyst, TechAble',
      logoPath: 'lib/images/Logo/Tech Able.png',
      text: '"If this works reliably, it would be a game-changer in hospitals and bus terminals."',
    ),
    _Quote(
      name: 'Hafiz',
      role: 'Librarian, SAVH Braille Library',
      logoPath: 'lib/images/Logo/SAVH.png',
      logoScale: 1.4,
      text: '"Very interesting. We\'d be happy to work with you to refine and deploy this."',
    ),
    _Quote(
      name: 'Lynn Wee',
      role: 'Senior UX Researcher, 55 Minutes',
      logoPath: 'lib/images/Logo/55mins.png',
      text: '"Cool project. National Gallery Singapore is exploring indoor navigation with BLE — you should connect."',
    ),
  ];

  static const _orgs = ['AWWA', 'SAVH', 'TechAble', 'SGEnable', 'National Gallery SG'];

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'STAKEHOLDER\nINSIGHTS',
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        height: 0.95,
                        letterSpacing: -1.5,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.end,
                        children: _orgs
                            .map((o) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(o,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700)),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Organisations engaged across social service, accessibility, design, and arts sectors.',
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
                const SizedBox(height: 20),
                // 4 floating quote cards
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < _quotes.length; i++) ...[
                        Expanded(
                          child: Reveal(
                            delayMs: i * 90,
                            child: _quoteCard(_quotes[i]),
                          ),
                        ),
                        if (i != _quotes.length - 1)
                          const SizedBox(width: 14),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Potential applications bar
                Reveal(
                  delayMs: 420,
                  child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5C842),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.lightbulb_outline,
                            size: 22, color: Colors.black),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'POTENTIAL IS VAST',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: Color(0xFFF5C842),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Supermarkets · Hospitals · Bus Terminals · Schools · Campuses · Museums',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quoteCard(_Quote q) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo above quote — centered, taller
          ClipRect(
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: Transform.scale(
                scale: q.logoScale,
                child: Image.asset(
                  q.logoPath,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Quote text
          Expanded(
            child: Text(
              q.text,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Attribution row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5C842),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('"',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          height: 1.2)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(q.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: Colors.black)),
                    Text(q.role,
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black45)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Quote {
  final String name;
  final String role;
  final String logoPath;
  final String text;
  final double logoScale;
  const _Quote(
      {required this.name,
      required this.role,
      required this.logoPath,
      required this.text,
      this.logoScale = 1.0});
}

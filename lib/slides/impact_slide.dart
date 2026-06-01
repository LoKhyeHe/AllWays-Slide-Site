import 'package:flutter/material.dart';
import '../widgets/washi_tape.dart';
import '../widgets/reveal.dart';

class ImpactSlide extends StatelessWidget {
  const ImpactSlide({super.key});

  static const _partners = [
    _Partner('SAVH', 'Singapore Association of the Visually Handicapped',
        logoPath: 'lib/images/Logo/SAVH.png'),
    _Partner('AWWA', 'Social service org serving multi-need communities',
        logoPath: 'lib/images/Logo/awwa.png'),
    _Partner('SGEnable', 'Lead agency for disability development in Singapore',
        logoPath: 'lib/images/Logo/SGEnable.png'),
  ];

  static const _groups = [
    _Group(Icons.visibility_off_outlined, 'Visually Impaired',
        'Students, adults & seniors navigating independently'),
    _Group(Icons.family_restroom_outlined, 'Caregivers & Families',
        'Reduced need to accompany and guide'),
    _Group(Icons.school_outlined, 'Schools & Educators',
        'Safer, more inclusive learning environments'),
    _Group(Icons.local_hospital_outlined, 'Facility Operators',
        'Hospitals, malls, transport hubs'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 760;
    return Container(
      color: const Color(0xFFF5C842),
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
            'IMPACT VISION',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 0.95,
              letterSpacing: -1.5,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          const WashiTape(color: Color(0xFFB8D4C8), width: 90, height: 22),
          const SizedBox(height: 24),
          const Text(
            'WHO BENEFITS',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: Colors.black54),
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < _groups.length; i++) ...[
            Reveal(delayMs: i * 70, child: _groupCard(_groups[i])),
            if (i != _groups.length - 1) const SizedBox(height: 10),
          ],
          const SizedBox(height: 24),
          const Text(
            'BENEFICIARY PARTNERS',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: Colors.black54),
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < _partners.length; i++) ...[
            _partnerCard(_partners[i]),
            if (i != _partners.length - 1) const SizedBox(height: 10),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.alt_route_outlined,
                    size: 18, color: Colors.black54),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('REACH STRATEGY',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: Colors.black54)),
                      SizedBox(height: 6),
                      Text(
                        'Pilots with AWWA, SAVH, and SGEnable — reaching visually impaired users in school and community settings, before expanding to hospitals and public transit.',
                        style: TextStyle(
                            fontSize: 13, color: Colors.black87, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Reveal(
            delayMs: 200,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'OUR MISSION',
                    style: TextStyle(
                      color: Color(0xFFF5C842),
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Make indoor spaces navigable — independently — for every visually impaired person.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktop() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Left column ───────────────────────────────────────────────
            Expanded(
              flex: 5,
              child: Reveal(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'IMPACT\nVISION',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      height: 0.92,
                      letterSpacing: -2,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const WashiTape(
                      color: Color(0xFFB8D4C8), width: 90, height: 22),
                  const SizedBox(height: 24),
                  const Text(
                    'BENEFICIARY PARTNERS',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Column(
                      children: _partners
                          .expand((p) => [
                                Expanded(child: _partnerCard(p)),
                                if (p != _partners.last)
                                  const SizedBox(height: 10),
                              ])
                          .toList(),
                    ),
                  ),
                ],
              ),
              ),
            ),
            const SizedBox(width: 32),
            // ── Right column ──────────────────────────────────────────────
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // WHO BENEFITS — 2×2 grid
                  const Text(
                    'WHO BENEFITS',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: Reveal(delayMs: 100, child: _groupCard(_groups[0]))),
                              const SizedBox(width: 10),
                              Expanded(child: Reveal(delayMs: 180, child: _groupCard(_groups[1]))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: Reveal(delayMs: 260, child: _groupCard(_groups[2]))),
                              const SizedBox(width: 10),
                              Expanded(child: Reveal(delayMs: 340, child: _groupCard(_groups[3]))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // REACH STRATEGY
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.alt_route_outlined,
                            size: 18, color: Colors.black54),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('REACH STRATEGY',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                      color: Colors.black54)),
                              SizedBox(height: 6),
                              Text(
                                'Pilots with AWWA, SAVH, and SGEnable — reaching visually impaired users in school and community settings, before expanding to hospitals and public transit.',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // OUR MISSION
                  Expanded(
                    flex: 3,
                    child: Reveal(
                      delayMs: 420,
                      child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'OUR MISSION',
                            style: TextStyle(
                              color: Color(0xFFF5C842),
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Make indoor spaces navigable — independently — for every visually impaired person.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
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

  Widget _partnerCard(_Partner p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          Container(
            width: 80,
            height: 44,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Image.asset(
              p.logoPath!,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ),
          Container(
            width: 1,
            height: 36,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: Colors.white12,
          ),
          Expanded(
            child: Text(
              p.description,
              style: const TextStyle(
                  color: Colors.white60, fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupCard(_Group g) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(g.icon, size: 20, color: Colors.black87),
          const SizedBox(height: 8),
          Text(g.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: Colors.black)),
          const SizedBox(height: 4),
          Text(g.sub,
              style: const TextStyle(
                  fontSize: 11, color: Colors.black54, height: 1.3)),
        ],
      ),
    );
  }
}

class _Partner {
  final String name;
  final String description;
  final String? logoPath;
  const _Partner(this.name, this.description, {this.logoPath});
}

class _Group {
  final IconData icon;
  final String title;
  final String sub;
  const _Group(this.icon, this.title, this.sub);
}

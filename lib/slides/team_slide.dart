import 'package:flutter/material.dart';
import '../widgets/washi_tape.dart';

class TeamSlide extends StatelessWidget {
  const TeamSlide({super.key});

  static const _members = [
    _Member(
      name: 'Khye He',
      role: 'Product & Business Development',
      focus: 'Embedded systems, product design, and human-centred development.',
      photo: 'lib/images/Headshots/Khye he.jpg',
    ),
    _Member(
      name: 'Lee Yi Xiang',
      role: 'Mechanical & Electronics',
      focus: 'UWB hardware, embedded systems, and mechanical integration.',
      photo: 'lib/images/Headshots/YiXiang.jpg',
    ),
    _Member(
      name: 'Ngo Eu Gene',
      role: 'Design and Product',
      focus: 'Belt ergonomics, industrial design, and prototype assembly.',
      photo: 'lib/images/Headshots/Eu Gene.jpg',
      photoAlignment: Alignment.topCenter,
    ),
    _Member(
      name: 'Rachel Kok',
      role: 'Electronics and UI/UX',
      focus: 'Circuit design, accessible interface design, and user research.',
      photo: 'lib/images/Headshots/Rachel.jpg',
    ),
    _Member(
      name: 'Jaryl Chan',
      role: 'Software Architecture',
      focus: 'Navigation algorithms, app development, and system integration.',
      photo: 'lib/images/Headshots/Jaryl.jpg',
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
            padding: const EdgeInsets.fromLTRB(48, 36, 48, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'THE TEAM',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    height: 0.95,
                    letterSpacing: -1.5,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _members
                        .expand((m) => [
                              Expanded(child: _memberCard(m)),
                              if (m != _members.last)
                                const SizedBox(width: 14),
                            ])
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberCard(_Member m) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Photo
          Expanded(
            flex: 6,
            child: Image.asset(
              m.photo,
              fit: BoxFit.cover,
              alignment: m.photoAlignment,
            ),
          ),
          // Yellow accent line
          Container(height: 3, color: const Color(0xFFF5C842)),
          // Info
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    m.role,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF5C842),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      m.focus,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        height: 1.4,
                      ),
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
}

class _Member {
  final String name;
  final String role;
  final String focus;
  final String photo;
  final Alignment photoAlignment;
  const _Member(
      {required this.name,
      required this.role,
      required this.focus,
      required this.photo,
      this.photoAlignment = Alignment.topCenter});
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/washi_tape.dart';
import '../widgets/reveal.dart';

class TeamSlide extends StatelessWidget {
  const TeamSlide({super.key});

  static const _members = [
    _Member(
      name: 'Khye He',
      role: 'Product & Business Development',
      focus: 'Embedded systems, product design, and human-centred development.',
      photo: 'lib/images/Headshots/Khye he.jpg',
      linkedin: 'https://linkedin.com/in/khyehe',
      portfolio: 'https://lokhyehe.github.io/KhyeFolio/',
    ),
    _Member(
      name: 'Lee Yi Xiang',
      role: 'Mechanical & Electronics',
      focus: 'UWB hardware, embedded systems, and mechanical integration.',
      photo: 'lib/images/Headshots/YiXiang.jpg',
      linkedin: 'https://linkedin.com/in/lee-yi-xiang',
    ),
    _Member(
      name: 'Ngo Eu Gene',
      role: 'Design and Product',
      focus: 'Belt ergonomics, industrial design, and prototype assembly.',
      photo: 'lib/images/Headshots/Eu Gene.jpg',
      photoAlignment: Alignment.topCenter,
      linkedin: 'https://linkedin.com/in/ngoeugene',
    ),
    _Member(
      name: 'Rachel Kok',
      role: 'Electronics and UI/UX',
      focus: 'Circuit design, accessible interface design, and user research.',
      photo: 'lib/images/Headshots/Rachel.jpg',
      linkedin: 'https://linkedin.com/in/rachelkokjingyi',
    ),
    _Member(
      name: 'Jaryl Chan',
      role: 'Software Architecture',
      focus: 'Navigation algorithms, app development, and system integration.',
      photo: 'lib/images/Headshots/Jaryl.jpg',
      linkedin: 'https://linkedin.com/in/jaryl-chan-jun-xiang',
    ),
  ];

  Future<void> _open(String url) async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 760;
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          CustomPaint(painter: GridPainter(), size: Size.infinite),
          if (isMobile) _mobile() else _desktop(),
        ],
      ),
    );
  }

  Widget _desktop() {
    return Padding(
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
                    children: [
                      for (int i = 0; i < _members.length; i++) ...[
                        Expanded(
                          child: Reveal(
                            delayMs: i * 90,
                            child: _memberCard(_members[i]),
                          ),
                        ),
                        if (i != _members.length - 1)
                          const SizedBox(width: 14),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _mobile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'THE TEAM',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 0.95,
              letterSpacing: -1.5,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < _members.length; i++) ...[
            Reveal(delayMs: i * 70, child: _mobileCard(_members[i])),
            if (i != _members.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }

  Widget _mobileCard(_Member m) {
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
          SizedBox(
            height: 240,
            child: Image.asset(
              m.photo,
              fit: BoxFit.cover,
              alignment: m.photoAlignment,
            ),
          ),
          Container(height: 3, color: const Color(0xFFF5C842)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  m.role,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF5C842),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  m.focus,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _LinkChip(
                      icon: _linkedInGlyph(),
                      label: 'LinkedIn',
                      onTap: () => _open(m.linkedin),
                    ),
                    if (m.portfolio != null) ...[
                      const SizedBox(width: 8),
                      _LinkChip(
                        icon: const Icon(Icons.language,
                            size: 14, color: Colors.black87),
                        label: 'WebFolio',
                        onTap: () => _open(m.portfolio!),
                      ),
                    ],
                  ],
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _LinkChip(
                        icon: _linkedInGlyph(),
                        label: 'LinkedIn',
                        onTap: () => _open(m.linkedin),
                      ),
                      if (m.portfolio != null) ...[
                        const SizedBox(width: 8),
                        _LinkChip(
                          icon: const Icon(Icons.language,
                              size: 14, color: Colors.black87),
                          label: 'WebFolio',
                          onTap: () => _open(m.portfolio!),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _linkedInGlyph() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: const Color(0xFF0A66C2),
        borderRadius: BorderRadius.circular(3),
      ),
      alignment: Alignment.center,
      child: const Text(
        'in',
        style: TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _LinkChip extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  const _LinkChip(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
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
  final String linkedin;
  final String? portfolio;
  const _Member(
      {required this.name,
      required this.role,
      required this.focus,
      required this.photo,
      required this.linkedin,
      this.portfolio,
      this.photoAlignment = Alignment.topCenter});
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/washi_tape.dart';
import '../widgets/reveal.dart';

class ContactSlide extends StatelessWidget {
  const ContactSlide({super.key});

  static const _email = 'khyehe_lo@mymail.sutd.edu.sg';

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _email,
      query: 'subject=${Uri.encodeComponent('AllWays — Collaboration Enquiry')}',
    );
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          CustomPaint(painter: GridPainter(color: Colors.white10), size: Size.infinite),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 40),
            child: Center(
              child: Reveal(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'INTERESTED IN\nWORKING WITH US?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        height: 0.98,
                        letterSpacing: -2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(
                      width: 620,
                      child: Text(
                        'We\'re looking for pilot partners, facilities, and collaborators to bring accessible indoor navigation to the people who need it. Reach out — we\'d love to talk.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _EmailButton(onTap: _sendEmail),
                    const SizedBox(height: 28),
                    const Text(
                      'AllWays',
                      style: TextStyle(
                          fontSize: 11, color: Colors.white38, letterSpacing: 1),
                    ),
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

class _EmailButton extends StatelessWidget {
  final VoidCallback onTap;
  const _EmailButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF5C842),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.mail_outline, size: 20, color: Colors.black),
              const SizedBox(width: 12),
              const Text(
                'Email Us',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

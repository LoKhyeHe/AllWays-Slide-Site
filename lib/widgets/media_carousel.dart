import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// A single item in the carousel — either an image or a video asset.
/// The caption is split into four optional lines shown below the media:
/// [title], [name], [organisation] and [action]. They update (with a fade)
/// as the active item changes.
class CarouselItem {
  final String assetPath;
  final bool isVideo;
  final String title;
  final String name;
  final String organisation;
  final String action;
  const CarouselItem.image(
    this.assetPath, {
    this.title = '',
    this.name = '',
    this.organisation = '',
    this.action = '',
  }) : isVideo = false;
  const CarouselItem.video(
    this.assetPath, {
    this.title = '',
    this.name = '',
    this.organisation = '',
    this.action = '',
  }) : isVideo = true;

  bool get hasCaption =>
      title.isNotEmpty ||
      name.isNotEmpty ||
      organisation.isNotEmpty ||
      action.isNotEmpty;
}

/// Horizontal swipeable carousel of images/videos with arrows + dots.
/// Scrolls infinitely in both directions (the last item flows straight into
/// the first, with no snap-back). The video auto-plays (muted, looping) when
/// it is the active page and pauses when the user switches away.
class MediaCarousel extends StatefulWidget {
  final List<CarouselItem> items;
  final double borderRadius;
  const MediaCarousel({
    super.key,
    required this.items,
    this.borderRadius = 8,
  });

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  late final PageController _pageController;
  // Active item index in 0..items.length-1 (used for dots, caption, video).
  int _index = 0;
  // Current absolute page position (may be far from 0 due to infinite paging).
  late double _page;

  // A large starting page so the user can scroll far in either direction
  // before hitting the (practically unreachable) ends. Kept as a multiple of
  // items.length so the initial real index is 0.
  late final int _basePage;

  // One controller per video item, keyed by item index.
  final Map<int, VideoPlayerController> _videos = {};
  // Error message per video item, if initialization failed.
  final Map<int, String> _videoErrors = {};

  int get _len => widget.items.length;

  @override
  void initState() {
    super.initState();
    _basePage = _len * 1000;
    _page = _basePage.toDouble();
    // viewportFraction well below 1 so the centre item is narrower and the
    // neighbouring media stay clearly visible on both sides.
    _pageController = PageController(
      viewportFraction: 0.6,
      initialPage: _basePage,
    )..addListener(() {
        final p = _pageController.page;
        if (p != null) setState(() => _page = p);
      });
    for (var i = 0; i < _len; i++) {
      final item = widget.items[i];
      if (item.isVideo) {
        final c = VideoPlayerController.asset(item.assetPath);
        _videos[i] = c;
        c.initialize().then((_) {
          if (!mounted) return;
          c.setLooping(true);
          c.setVolume(0); // muted so web autoplay is allowed
          if (_index == i) c.play();
          setState(() {});
        }).catchError((e) {
          if (!mounted) return;
          setState(() => _videoErrors[i] = e.toString());
        });
      }
    }
  }

  @override
  void dispose() {
    for (final c in _videos.values) {
      c.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int absolutePage) {
    final real = absolutePage % _len;
    setState(() => _index = real);
    _videos.forEach((idx, c) {
      if (idx == real) {
        c.play();
      } else {
        c.pause();
      }
    });
  }

  void _go(int delta) {
    // Move relative to the current absolute page so the loop is seamless —
    // going right past the last item flows straight into the first.
    final cur = (_pageController.page ?? _basePage.toDouble()).round();
    _pageController.animateToPage(
      cur + delta,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildPage(int i) {
    final item = widget.items[i];
    if (item.isVideo) {
      final c = _videos[i];
      final err = _videoErrors[i];
      if (err != null) {
        return Container(
          color: Colors.black,
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    color: Color(0xFFF5C842), size: 32),
                const SizedBox(height: 8),
                Text(
                  'Video failed to load\n$err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
        );
      }
      if (c == null || !c.value.isInitialized) {
        return Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFFF5C842)),
          ),
        );
      }
      return GestureDetector(
        onTap: () {
          setState(() {
            c.value.isPlaying ? c.pause() : c.play();
          });
        },
        child: Container(
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: c.value.aspectRatio,
                  child: VideoPlayer(c),
                ),
              ),
              if (!c.value.isPlaying)
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow,
                        color: Colors.white, size: 34),
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return Image.asset(
      item.assetPath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  // All caption fields joined into a single grey line, e.g.
  // "Tech Analyst · Kwek Bin · TechAble · Testing AllWays Belt Haptic Feedback".
  String _captionText(CarouselItem item) =>
      [item.title, item.name, item.organisation, item.action]
          .where((s) => s.isNotEmpty)
          .join('   ·   ');

  @override
  Widget build(BuildContext context) {
    final active = widget.items[_index];
    return Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                // Effectively infinite: a huge count centred on _basePage.
                itemCount: _len > 1 ? _basePage * 2 : 1,
                itemBuilder: (_, i) {
                  final real = i % _len;
                  final item = widget.items[real];
                  // Distance of this page from the centre (0 = centred).
                  final dist = (_page - i).abs().clamp(0.0, 1.0);
                  // Centre item is largest; neighbours shrink only slightly so
                  // they stay clearly visible.
                  final scale = 1.0 - dist * 0.14;
                  Widget media = ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: _buildPage(real),
                  );
                  // Photos are shown as taller, narrower (portrait) cards so
                  // they crop to a tighter frame; the video keeps its width.
                  if (!item.isVideo) {
                    media = AspectRatio(aspectRatio: 3 / 4, child: media);
                  }
                  return Center(
                    child: Transform.scale(
                      scale: scale,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: media,
                      ),
                    ),
                  );
                },
              ),
              // Left arrow
              if (_len > 1)
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                      child: _arrow(Icons.chevron_left, () => _go(-1))),
                ),
              // Right arrow
              if (_len > 1)
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                      child: _arrow(Icons.chevron_right, () => _go(1))),
                ),
              // Dots
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < _len; i++)
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == _index
                              ? const Color(0xFFF5C842)
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Single grey caption line — fades as the active item changes.
        if (active.hasCaption) ...[
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              _captionText(active),
              key: ValueKey(_index),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white54,
                height: 1.3,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _arrow(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

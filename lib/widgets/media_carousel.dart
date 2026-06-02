import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// A single item in the carousel — either an image or a video asset.
class CarouselItem {
  final String assetPath;
  final bool isVideo;
  const CarouselItem.image(this.assetPath) : isVideo = false;
  const CarouselItem.video(this.assetPath) : isVideo = true;
}

/// Horizontal swipeable carousel of images/videos with arrows + dots.
/// The video auto-plays (muted, looping) when it is the active page and
/// pauses when the user switches away.
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
  int _index = 0;
  double _page = 0;

  // One controller per video item, keyed by item index.
  final Map<int, VideoPlayerController> _videos = {};
  // Error message per video item, if initialization failed.
  final Map<int, String> _videoErrors = {};

  @override
  void initState() {
    super.initState();
    // viewportFraction < 1 so the previous/next items peek on each side.
    _pageController = PageController(viewportFraction: 0.74)
      ..addListener(() {
        final p = _pageController.page;
        if (p != null) setState(() => _page = p);
      });
    for (var i = 0; i < widget.items.length; i++) {
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

  void _onPageChanged(int i) {
    setState(() => _index = i);
    _videos.forEach((idx, c) {
      if (idx == i) {
        c.play();
      } else {
        c.pause();
      }
    });
  }

  void _go(int delta) {
    final next = (_index + delta).clamp(0, widget.items.length - 1);
    _pageController.animateToPage(
      next,
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.items.length,
            itemBuilder: (_, i) {
              // Distance of this page from the centre (0 = centred).
              final dist = (_page - i).abs().clamp(0.0, 1.0);
              // Centre item is full-size; neighbours shrink and recede.
              final scale = 1.0 - dist * 0.22;
              return Center(
                child: Transform.scale(
                  scale: scale,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(widget.borderRadius),
                      child: _buildPage(i),
                    ),
                  ),
                ),
              );
            },
          ),
          // Left arrow
          if (_index > 0)
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(child: _arrow(Icons.chevron_left, () => _go(-1))),
            ),
          // Right arrow
          if (_index < widget.items.length - 1)
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(child: _arrow(Icons.chevron_right, () => _go(1))),
            ),
          // Dots
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < widget.items.length; i++)
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

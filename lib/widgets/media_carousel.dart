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

  // One controller per video item, keyed by item index.
  final Map<int, VideoPlayerController> _videos = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
          child: Center(
            child: AspectRatio(
              aspectRatio: c.value.aspectRatio,
              child: VideoPlayer(c),
            ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.items.length,
            itemBuilder: (_, i) => _buildPage(i),
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
      ),
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

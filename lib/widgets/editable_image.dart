import 'package:flutter/material.dart';
import '../models/image_config.dart';
import '../services/image_config_service.dart';

/// Drop-in replacement for Image.asset that supports interactive crop
/// repositioning and height resizing via a JSON config file.
///
/// [expand] — set true when the image lives inside an Expanded or
/// Positioned.fill, so edit-mode Stack uses StackFit.expand.
class EditableImage extends StatelessWidget {
  final String configKey;
  final String assetPath;
  final BoxFit fit;
  final double? width;
  final BorderRadius? borderRadius;
  final bool expand;

  const EditableImage({
    super.key,
    required this.configKey,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.width,
    this.borderRadius,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, ImageConfig>>(
      valueListenable: ImageConfigService.instance.configs,
      builder: (context, configs, _) {
        final config = configs[configKey] ?? const ImageConfig();
        return ValueListenableBuilder<bool>(
          valueListenable: ImageConfigService.instance.editMode,
          builder: (context, isEditing, _) {
            final img = _buildImage(config);
            return isEditing ? _buildEditOverlay(config, img) : img;
          },
        );
      },
    );
  }

  Widget _buildImage(ImageConfig config) {
    Widget img = Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: config.height,
      alignment: Alignment(config.alignX, config.alignY),
    );
    if (borderRadius != null) {
      img = ClipRRect(borderRadius: borderRadius!, child: img);
    }
    return img;
  }

  Widget _buildEditOverlay(ImageConfig config, Widget img) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth.isFinite ? constraints.maxWidth : 400.0;
      final h = config.height ??
          (constraints.maxHeight.isFinite ? constraints.maxHeight : 300.0);

      final children = <Widget>[
        img,
        // yellow border
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF5C842), width: 2),
                borderRadius: borderRadius,
              ),
            ),
          ),
        ),
        // key label (top-left)
        Positioned(
          top: 4,
          left: 4,
          child: IgnorePointer(child: _keyLabel()),
        ),
        // alignment readout (top-right)
        Positioned(
          top: 4,
          right: 4,
          child: IgnorePointer(child: _infoLabel(config)),
        ),
        // drag to reposition crop
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanUpdate: (d) {
              final newX = (config.alignX + d.delta.dx / w * 2).clamp(-1.0, 1.0);
              final newY = (config.alignY + d.delta.dy / h * 2).clamp(-1.0, 1.0);
              ImageConfigService.instance.updateConfig(
                configKey,
                config.copyWith(alignX: newX, alignY: newY),
              );
            },
          ),
        ),
        // resize handle — only shown when image has a config height
        if (config.height != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: (d) {
                final newH = (config.height! + d.delta.dy).clamp(50.0, 600.0);
                ImageConfigService.instance.updateConfig(
                  configKey,
                  config.copyWith(height: newH),
                );
              },
              child: Container(
                height: 16,
                color: const Color(0xFFF5C842).withValues(alpha: 0.85),
                child: const Icon(Icons.drag_handle, size: 14, color: Colors.black),
              ),
            ),
          ),
      ];

      // Fixed-height image: wrap in SizedBox so height is respected
      if (config.height != null) {
        return SizedBox(
          height: config.height,
          child: Stack(fit: StackFit.expand, children: children),
        );
      }
      // Expanded / Positioned.fill context: fill parent
      if (expand) {
        return Stack(fit: StackFit.expand, children: children);
      }
      // Natural-size image (e.g., BoxFit.contain): Stack sizes to image
      return Stack(children: children);
    });
  }

  Widget _keyLabel() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFF5C842),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          configKey,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      );

  Widget _infoLabel(ImageConfig config) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          'x:${config.alignX.toStringAsFixed(2)} '
          'y:${config.alignY.toStringAsFixed(2)}'
          '${config.height != null ? '  h:${config.height!.toStringAsFixed(0)}' : ''}',
          style: const TextStyle(fontSize: 9, color: Colors.white),
        ),
      );
}

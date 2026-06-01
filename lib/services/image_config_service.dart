import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/image_config.dart';

class ImageConfigService {
  ImageConfigService._();
  static final instance = ImageConfigService._();

  static const _storageKey = 'allways_image_config';

  final editMode = ValueNotifier<bool>(false);
  final configs = ValueNotifier<Map<String, ImageConfig>>({});

  Future<void> load() async {
    final jsonStr = await rootBundle.loadString('assets/image_config.json');
    final Map<String, dynamic> data = json.decode(jsonStr) as Map<String, dynamic>;
    final merged = data.map(
      (k, v) => MapEntry(k, ImageConfig.fromJson(v as Map<String, dynamic>)),
    );

    final stored = html.window.localStorage[_storageKey];
    if (stored != null) {
      try {
        final Map<String, dynamic> overrides =
            json.decode(stored) as Map<String, dynamic>;
        for (final entry in overrides.entries) {
          if (merged.containsKey(entry.key)) {
            merged[entry.key] =
                ImageConfig.fromJson(entry.value as Map<String, dynamic>);
          }
        }
      } catch (_) {}
    }

    configs.value = merged;
  }

  ImageConfig getConfig(String key) =>
      configs.value[key] ?? const ImageConfig();

  void updateConfig(String key, ImageConfig config) {
    final updated = Map<String, ImageConfig>.from(configs.value);
    updated[key] = config;
    configs.value = updated;
    html.window.localStorage[_storageKey] =
        json.encode(updated.map((k, v) => MapEntry(k, v.toJson())));
  }

  void downloadConfig() {
    final jsonStr = const JsonEncoder.withIndent('  ')
        .convert(configs.value.map((k, v) => MapEntry(k, v.toJson())));
    final bytes = utf8.encode(jsonStr);
    final blob = html.Blob([bytes], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..download = 'image_config.json'
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}

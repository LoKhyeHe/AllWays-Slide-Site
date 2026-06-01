import 'package:flutter/material.dart';

class SlideModel {
  final String id;
  final String label;
  final Widget Function(BuildContext context) builder;

  const SlideModel({
    required this.id,
    required this.label,
    required this.builder,
  });
}

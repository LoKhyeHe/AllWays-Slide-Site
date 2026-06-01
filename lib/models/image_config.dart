class ImageConfig {
  final double alignX;
  final double alignY;
  final double? height;

  const ImageConfig({this.alignX = 0.0, this.alignY = 0.0, this.height});

  ImageConfig copyWith({double? alignX, double? alignY, double? height}) {
    return ImageConfig(
      alignX: alignX ?? this.alignX,
      alignY: alignY ?? this.alignY,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toJson() => {
        'alignX': alignX,
        'alignY': alignY,
        if (height != null) 'height': height,
      };

  factory ImageConfig.fromJson(Map<String, dynamic> json) => ImageConfig(
        alignX: (json['alignX'] as num?)?.toDouble() ?? 0.0,
        alignY: (json['alignY'] as num?)?.toDouble() ?? 0.0,
        height: (json['height'] as num?)?.toDouble(),
      );
}

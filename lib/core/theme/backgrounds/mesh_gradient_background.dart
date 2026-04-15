import 'package:flutter/material.dart';

class MeshGradientBackground extends StatelessWidget {
  const MeshGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final colors = _MeshColors.fromScheme(scheme);

    return RepaintBoundary(
      child: CustomPaint(
        painter: _MeshGradientPainter(colors),
        size: Size.infinite,
      ),
    );
  }
}

class _MeshColors {
  final Color a;
  final Color b;
  final Color c;

  const _MeshColors(this.a, this.b, this.c);

  factory _MeshColors.fromScheme(ColorScheme scheme) {
    return _MeshColors(
      scheme.primary.withAlpha(25),
      scheme.secondary.withAlpha(22),
      scheme.tertiary.withAlpha(20),
    );
  }
}

class _MeshGradientPainter extends CustomPainter {
  final _MeshColors colors;

  _MeshGradientPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint();

    paint.shader =
        RadialGradient(
          colors: [colors.a, Colors.transparent],
          stops: const [0.25, 1],
        ).createShader(
          Rect.fromCircle(
            center: Offset(size.width * 0.2, size.height * 0.25),
            radius: size.width * 0.7,
          ),
        );
    canvas.drawRect(rect, paint);

    paint.shader =
        RadialGradient(
          colors: [colors.b, Colors.transparent],
          stops: const [0.25, 1],
        ).createShader(
          Rect.fromCircle(
            center: Offset(size.width * 0.85, size.height * 0.4),
            radius: size.width * 0.75,
          ),
        );
    canvas.drawRect(rect, paint);

    paint.shader =
        RadialGradient(
          colors: [colors.c, Colors.transparent],
          stops: const [0.25, 1],
        ).createShader(
          Rect.fromCircle(
            center: Offset(size.width * 0.5, size.height * 0.85),
            radius: size.width * 0.9,
          ),
        );
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _MeshGradientPainter oldDelegate) {
    return oldDelegate.colors != colors;
  }
}

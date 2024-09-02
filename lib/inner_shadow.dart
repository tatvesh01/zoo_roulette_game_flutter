import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    Key? key,
    this.blur = 0,
    this.color = Colors.transparent,
    this.offset = const Offset(0, 0),
    Widget? child,
  }) : super(key: key, child: child);

  final double blur;
  final Color color;
  final Offset offset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final _RenderInnerShadow renderObject = _RenderInnerShadow();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(BuildContext context, _RenderInnerShadow renderObject) {
    renderObject
      ..color = color
      ..blur = blur
      ..dx = offset.dx
      ..dy = offset.dy;
  }
}

class _RenderInnerShadow extends RenderProxyBox {
  double blur = 0;
  Color color = Colors.transparent;
  double dx = 0;
  double dy = 0;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final Rect rectOuter = offset & size;
    final Rect rectInner = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width - dx,
      size.height - dy,
    );
    final Canvas canvas = context.canvas..saveLayer(rectOuter, Paint());
    context.paintChild(child!, offset);
    final Paint shadowPaint = Paint()
      ..blendMode = BlendMode.srcATop
      ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
      ..colorFilter = ColorFilter.mode(color, BlendMode.srcOut);

    canvas
      ..saveLayer(rectOuter, shadowPaint)
      ..saveLayer(rectInner, Paint())
      ..translate(dx, dy);
    context.paintChild(child!, offset);
    context.canvas
      ..restore()
      ..restore()
      ..restore();
  }
}

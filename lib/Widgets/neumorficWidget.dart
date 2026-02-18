import 'package:flutter/material.dart';
import 'package:wp_app/colors.dart';

/// Widget con Drop Shadow (ombra esterna)
class DropShadowWidget extends StatelessWidget {
  final Widget? child;
  final double width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;

  const DropShadowWidget({
    Key? key,
    this.child,
    this.width = 150,
    this.height = 150,
    this.borderRadius = 30,
    this.backgroundColor = background_color,
    this.shadowColor = shadow_color,
    this.blurRadius = 30,
    this.offset = const Offset(18, 18),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: offset,
            blurRadius: blurRadius,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Widget con Inner Shadow (ombra interna) - Stile 1
class InnerShadowWidget1 extends StatelessWidget {
  final Widget? child;
  final double width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;

  const InnerShadowWidget1({
    Key? key,
    this.child,
    this.width = 150,
    this.height = 150,
    this.borderRadius = 30,
    this.backgroundColor = background_color,
    this.shadowColor = shadow_color,
    this.blurRadius = 30,
    this.offset = const Offset(18, 18),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: InnerShadowPainter(
                  shadowColor: shadowColor,
                  blurRadius: blurRadius,
                  offset: offset,
                  borderRadius: borderRadius,
                ),
              ),
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}

/// Widget con Inner Shadow (ombra interna) - Stile 2 (circolare)
class InnerShadowWidget2 extends StatelessWidget {
  final Widget? child;
  final double size;
  final Color backgroundColor;
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;

  const InnerShadowWidget2({
    Key? key,
    this.child,
    this.size = 150,
    this.backgroundColor = background_color,
    this.shadowColor = shadow_color,
    this.blurRadius = 30,
    this.offset = const Offset(-18, -18),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: InnerShadowCircularPainter(
                  shadowColor: shadowColor,
                  blurRadius: blurRadius,
                  offset: offset,
                ),
              ),
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}

/// Custom Painter per Inner Shadow rettangolare
class InnerShadowPainter extends CustomPainter {
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;
  final double borderRadius;

  InnerShadowPainter({
    required this.shadowColor,
    required this.blurRadius,
    required this.offset,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    canvas.saveLayer(rect, Paint());
    canvas.clipRRect(rrect);

    final shadowRect = rect.shift(offset);
    final shadowPath = Path()..addRRect(RRect.fromRectAndRadius(shadowRect, Radius.circular(borderRadius)));

    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = shadowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius),
    );

    canvas.drawRRect(
      rrect,
      Paint()..blendMode = BlendMode.clear,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom Painter per Inner Shadow circolare
class InnerShadowCircularPainter extends CustomPainter {
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;

  InnerShadowCircularPainter({
    required this.shadowColor,
    required this.blurRadius,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.saveLayer(rect, Paint());
    canvas.clipPath(Path()..addOval(rect));

    final shadowCenter = center + offset;

    canvas.drawCircle(
      shadowCenter,
      radius,
      Paint()
        ..color = shadowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius),
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()..blendMode = BlendMode.clear,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Widget Neomorfico completo con ombra interna ed esterna
class NeumorphicWidget extends StatelessWidget {
  final Widget? child;
  final double width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final bool isPressed;
  final bool isCircular;

  const NeumorphicWidget({
    Key? key,
    this.child,
    this.width = 150,
    this.height = 150,
    this.borderRadius = 30,
    this.backgroundColor = background_color,
    this.isPressed = false,
    this.isCircular = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPressed) {
      if (isCircular) {
        return InnerShadowWidget2(
          size: width,
          backgroundColor: backgroundColor,
          child: child,
        );
      }
      return InnerShadowWidget1(
        width: width,
        height: height,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        child: child,
      );
    }

    return DropShadowWidget(
      width: width,
      height: height,
      borderRadius: isCircular ? width / 2 : borderRadius,
      backgroundColor: backgroundColor,
      child: child,
    );
  }
}

/// Bottone Neomorfico interattivo
class NeumorphicButton extends StatefulWidget {
  final Widget? child;
  final double width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final bool isCircular;

  const NeumorphicButton({
    Key? key,
    this.child,
    this.width = 150,
    this.height = 150,
    this.borderRadius = 30,
    this.backgroundColor = background_color,
    this.onTap,
    this.isCircular = false,
  }) : super(key: key);

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: NeumorphicWidget(
        width: widget.width,
        height: widget.height,
        borderRadius: widget.borderRadius,
        backgroundColor: widget.backgroundColor,
        isPressed: _isPressed,
        isCircular: widget.isCircular,
        child: widget.child,
      ),
    );
  }
}
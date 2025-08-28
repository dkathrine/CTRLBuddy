import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MsgMenuBtn extends StatefulWidget {
  const MsgMenuBtn({
    super.key,
    this.size = 50,
    this.borderRadius = 12,
    this.borderThickness = 3,
    this.duration = const Duration(milliseconds: 650),
    this.gradient = const LinearGradient(
      colors: [Color(0xFF007BFF), Color(0xFFC800FF)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    this.icon = const Icon(
      LucideIcons.mail,
      size: 35,
      color: Color(0xFFF1F1F1),
    ),
    this.onOpen,
    this.onClose,
  });

  final double size;
  final double borderRadius;
  final double borderThickness;
  final Duration duration;
  final LinearGradient gradient;
  final Widget icon;

  // Called when the forward animation finishes
  final VoidCallback? onOpen;

  // Called when the reverse animation finishes
  final VoidCallback? onClose;

  @override
  State<MsgMenuBtn> createState() => _MsgMenuBtnState();
}

class _MsgMenuBtnState extends State<MsgMenuBtn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _gradBall; // gradient ball progress
  late final Animation<double> _bgBall; // background ball progress

  bool _isOpen = false; // logical state after animation finishes

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _gradBall = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOutCubic),

      reverseCurve: const Interval(0.6, 1.0, curve: Curves.easeInOutCubic),
    );

    _bgBall = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOutCubic),

      reverseCurve: const Interval(0.0, 0.4, curve: Curves.easeInOutCubic),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isOpen = true;
        widget.onOpen?.call();
      } else if (status == AnimationStatus.dismissed) {
        _isOpen = false;
        widget.onClose?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isOpen) {
      _controller.reverse(); // play close animation
    } else {
      _controller.forward(); // play open animation
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color baseBg = Theme.of(context).scaffoldBackgroundColor;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Material(
          color: baseBg,
          child: InkWell(
            // InkWell keeps hit test perfect and avoids any layout shift of the icon
            onTap: _toggle,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _TwoBubblePainter(
                      gradProgress: _gradBall.value,
                      bgProgress: _bgBall.value,
                      gradient: widget.gradient,
                      backgroundColor: baseBg,
                      borderRadius: widget.borderRadius,
                      borderThickness: widget.borderThickness,
                    ),
                    child: Center(child: widget.icon), // icon never moves
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints the exact "two-ball" Figma construction but with rounded rectangles:
/// - First (underlay): a gradient rounded rectangle grows from center (gradProgress).
/// - Second (overlay): a background-colored rounded rectangle grows (bgProgress),
///   stopping slightly smaller so it leaves a gradient ring (the "border").
///
/// Everything is clipped to the same rounded-rect as the button so
/// the fill never bleeds outside the shape.
class _TwoBubblePainter extends CustomPainter {
  _TwoBubblePainter({
    required this.gradProgress,
    required this.bgProgress,
    required this.gradient,
    required this.backgroundColor,
    required this.borderRadius,
    required this.borderThickness,
  });

  final double gradProgress;
  final double bgProgress;
  final LinearGradient gradient;
  final Color backgroundColor;
  final double borderRadius;
  final double borderThickness;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect clip = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    canvas.save();
    canvas.clipRRect(clip);

    // Gradient rectangle grows from center to full size
    if (gradProgress > 0) {
      final double progress = gradProgress;
      final double currentWidth = size.width * progress;
      final double currentHeight = size.height * progress;

      final Rect gradRect = Rect.fromCenter(
        center: rect.center,
        width: currentWidth,
        height: currentHeight,
      );

      final RRect gradRRect = RRect.fromRectAndRadius(
        gradRect,
        Radius.circular(borderRadius * progress),
      );

      final Paint grad = Paint()..shader = gradient.createShader(rect);
      canvas.drawRRect(gradRRect, grad);
    }

    // Background overlay rectangle (creates the border effect)
    if (bgProgress > 0) {
      final double borderOffset = borderThickness;
      final double bgWidth = (size.width - borderOffset * 2) * bgProgress;
      final double bgHeight = (size.height - borderOffset * 2) * bgProgress;

      final Rect bgRect = Rect.fromCenter(
        center: rect.center,
        width: bgWidth,
        height: bgHeight,
      );

      final double innerRadius = (borderRadius - borderOffset).clamp(
        0.0,
        borderRadius,
      );
      final RRect bgRRect = RRect.fromRectAndRadius(
        bgRect,
        Radius.circular(innerRadius * bgProgress),
      );

      final Paint bg = Paint()..color = backgroundColor;
      canvas.drawRRect(bgRRect, bg);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TwoBubblePainter old) {
    return gradProgress != old.gradProgress ||
        bgProgress != old.bgProgress ||
        gradient != old.gradient ||
        backgroundColor != old.backgroundColor ||
        borderRadius != old.borderRadius ||
        borderThickness != old.borderThickness;
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SpeedRing extends StatelessWidget {
  final int currentSpeed;
  final bool isPowerOn;
  final bool isOnline;
  final Function(int) onSpeedChanged;

  const SpeedRing({
    super.key,
    required this.currentSpeed,
    required this.isPowerOn,
    this.isOnline = true,
    required this.onSpeedChanged,
  });

  Duration _getRotationDuration() {
    if (!isPowerOn || !isOnline) return 0.ms;
    // Speed 1: 2000ms, Speed 6: 200ms
    final ms = 2000 - ((currentSpeed - 1) * 360);
    return (ms < 200 ? 200 : ms).ms;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = min(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            onPanUpdate: (details) {
              final center = Offset(size / 2, size / 2);
              final touchPosition = details.localPosition;
              final angle = atan2(
                touchPosition.dy - center.dy,
                touchPosition.dx - center.dx,
              );

              double degrees = angle * 180 / pi;
              if (degrees < 0) degrees += 360;

              double effectiveAngle = degrees;
              if (effectiveAngle < 90) effectiveAngle += 360;

              if (effectiveAngle >= 150 && effectiveAngle <= 390) {
                final percentage = (effectiveAngle - 150) / 240;
                int newSpeed = (percentage * 5).round() + 1;
                if (newSpeed < 1) newSpeed = 1;
                if (newSpeed > 6) newSpeed = 6;

                if (newSpeed != currentSpeed) {
                  onSpeedChanged(newSpeed);
                }
              }
            },
            child: CustomPaint(
              size: Size(size, size),
              painter: _SpeedRingPainter(
                speed: currentSpeed,
                color:
                    Theme.of(
                      context,
                    ).colorScheme.primary, // Use colorScheme for consistency
                trackColor: Theme.of(context).colorScheme.onSurface.withValues(
                  alpha: 0.1,
                ), // Adaptive track
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomPaint(
                          size: const Size(60, 60),
                          painter: _FanIconPainter(
                            // Use onSurface with low alpha for disabled state so it's visible but dim
                            color:
                                isPowerOn
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.3),
                          ),
                        )
                        .animate(
                          key: ValueKey(currentSpeed),
                          onPlay:
                              (controller) =>
                                  isPowerOn
                                      ? controller.repeat()
                                      : controller.stop(),
                        )
                        .rotate(
                          duration: _getRotationDuration(),
                          curve: Curves.linear,
                        ),

                    const SizedBox(height: 16),

                    Text(
                      currentSpeed == 6 ? 'BOOST' : '$currentSpeed',
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Text(
                      'SPEED',
                      style: TextStyle(fontSize: 14, letterSpacing: 3),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FanIconPainter extends CustomPainter {
  final Color color;

  _FanIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Draw center hub
    canvas.drawCircle(center, radius * 0.2, paint);

    // Draw 3 blades
    for (int i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate((i * 120) * pi / 180);

      final path = Path();
      // Blade shape
      path.moveTo(0, 0);
      path.cubicTo(
        radius * 0.5,
        -radius * 0.2,
        radius,
        -radius * 0.5,
        radius,
        0,
      );
      path.cubicTo(radius, radius * 0.5, radius * 0.5, radius * 0.8, 0, 0);
      path.close();

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_FanIconPainter oldDelegate) => oldDelegate.color != color;
}

class _SpeedRingPainter extends CustomPainter {
  final int speed; // 1-6
  final Color color;
  final Color trackColor;

  _SpeedRingPainter({
    required this.speed,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20; // Padding
    final strokeWidth = 25.0;

    final paintMock =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth;

    // Draw Track
    paintMock.color = trackColor;
    const startAngle = 150 * pi / 180;
    const sweepAngle = 240 * pi / 180; // Span

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paintMock,
    );

    // Draw Active Progress
    paintMock.color = color;

    // Map speed 1-6 to percentage
    // 1 -> 0% (start)
    // 6 -> 100% (end)
    final double percent = (speed - 1) / 5.0;
    final activeSweep = sweepAngle * percent;

    // Add shader or gradient for premium feel
    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: [color.withValues(alpha: 0.5), color],
      stops: const [0.0, 1.0],
      transform: GradientRotation(0), // Adjust if needed
    );

    paintMock.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      activeSweep,
      false,
      paintMock,
    );

    // Draw indicator circle at tip
    final endAngle = startAngle + activeSweep;
    final tipX = center.dx + radius * cos(endAngle);
    final tipY = center.dy + radius * sin(endAngle);

    final tipPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
    // Removed shadows property as it does not exist on Paint.
    // Shadows should be drawn via drawShadow or secondary pass.

    canvas.drawCircle(Offset(tipX, tipY), strokeWidth / 2 - 4, tipPaint);
  }

  @override
  bool shouldRepaint(covariant _SpeedRingPainter oldDelegate) {
    return oldDelegate.speed != speed || oldDelegate.color != color;
  }
}

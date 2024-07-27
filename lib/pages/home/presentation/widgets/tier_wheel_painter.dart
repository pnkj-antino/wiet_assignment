import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:wiet_assignment/pages/home/domain/home_state.dart';

class TierWheelPainter extends CustomPainter {
  final HomeState state;

  TierWheelPainter(this.state);
  intl.NumberFormat numberFormat = intl.NumberFormat.decimalPattern('en_US');

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Calculate gap in radians
    final gapRadians = 4 / radius;

    // Calculate sweep angle for each segment
    final sweepAngle = (math.pi / 2) - gapRadians;

    // Draw segments with text
    for (int i = 0; i < state.tiers.length; i++) {
      final tier = state.tiers[i];
      final startAngle = (i * math.pi / 2) - (math.pi / 2) - (gapRadians / 2);

      drawSegment(
          canvas,
          center,
          radius,
          startAngle,
          sweepAngle,
          Color(int.parse(tier.bgColor.toUpperCase().replaceAll("#", ""),
                  radix: 16) |
              0xFF000000),
          Color(int.parse(tier.fontColor.toUpperCase().replaceAll("#", ""),
              radix: 16)),
          tier.tierName,
          state.tiers[i] != state.tiers.last
              ? '${numberFormat.format(tier.minPoint)}-${numberFormat.format(tier.maxPoint)}'
              : '${numberFormat.format(tier.minPoint)}+');
    }

    // Draw pointer
    drawPointer(canvas, center, radius, state.tierPoints);

    // Draw center text
    drawCenterText(canvas, center, state.currentTier, state.tierPoints);
  }

  void drawSegment(
      Canvas canvas,
      Offset center,
      double radius,
      double startAngle,
      double sweepAngle,
      Color bgColor,
      Color textColor,
      String tierName,
      String tierRange) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50
      ..color = bgColor;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Draw tier name
    drawRotatedText(canvas, center, radius, startAngle + sweepAngle / 2,
        tierName, 20, FontWeight.bold, textColor);

    // Draw tier range
    drawRotatedText(canvas, center, radius + 40, startAngle + sweepAngle / 2,
        tierRange, 16, FontWeight.normal, textColor);
  }

  void drawRotatedText(
      Canvas canvas,
      Offset center,
      double radius,
      double angle,
      String text,
      double fontSize,
      FontWeight fontWeight,
      Color fontColor) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(radius, 0);

    if (angle >= 0 && angle < math.pi / 2) {
      // 1st quadrant
      canvas.rotate(-math.pi / 2);
    } else if (angle >= math.pi / 2 && angle < math.pi) {
      // 2nd quadrant
      canvas.rotate(-math.pi / 2);
    } else if (angle >= math.pi && angle < 3 * math.pi / 2) {
      // 3rd quadrant
      canvas.rotate(math.pi / 2);
    } else {
      // 4th quadrant
      canvas.rotate(math.pi / 2);
    }

    textPainter.paint(
        canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    canvas.restore();
  }

  void drawPointer(Canvas canvas, Offset center, double radius, int credits) {
    double angle = 0;
    for (var tier in state.tiers) {
      if (credits >= tier.minPoint && credits <= tier.maxPoint) {
        final tierIndex = state.tiers.indexOf(tier);
        final tierSweepAngle = (math.pi / 2) - (4 / radius);
        final tierStartAngle =
            (tierIndex * math.pi / 2) - (math.pi / 2) - (4 / radius / 2);
        final creditsFraction =
            (credits - tier.minPoint) / (tier.maxPoint - tier.minPoint);
        angle = tierStartAngle + creditsFraction * tierSweepAngle;
        break;
      }
    }

    final pointerPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final pointerLength = radius + 30;
    final pointerEnd = Offset(center.dx + pointerLength * math.cos(angle),
        center.dy + pointerLength * math.sin(angle));

    canvas.drawLine(
        Offset(center.dx + 115 * math.cos(angle),
            center.dy + 115 * math.sin(angle)),
        pointerEnd,
        pointerPaint);

    final circlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pointerEnd, 6, circlePaint);
  }

  void drawCenterText(
      Canvas canvas, Offset center, String tierName, int tierPoints) {
    int pointsToNextTier = 0;
    for (int i = 0; i < state.tiers.length; i++) {
      if (tierPoints >= state.tiers[i].minPoint &&
          tierPoints <= state.tiers[i].maxPoint) {
        if (i < state.tiers.length - 1) {
          pointsToNextTier = state.tiers[i + 1].minPoint - tierPoints;
        } else {
          pointsToNextTier = 0;
        }
        break;
      }
    }
    // Main text
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
              text: '$tierName\n',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          const TextSpan(
              text: 'TIER LEVEL',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey))
        ],
        style: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final containerWidth = textPainter.width + 20;
    final containerHeight = textPainter.height + 20;
    const cornerRadius = 12.0;

    // Draw the shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            center.dx - containerWidth / 2 - 5,
            center.dy - containerHeight / 2 - 60,
            containerWidth + 10,
            containerHeight + 10),
        const Radius.circular(cornerRadius),
      ),
      shadowPaint,
    );

    final containerPaint = Paint()
      ..color = Colors.white60
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            center.dx - containerWidth / 2,
            center.dy - containerHeight / 2 - 60,
            containerWidth,
            containerHeight),
        const Radius.circular(cornerRadius),
      ),
      containerPaint,
    );

    textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2,
            center.dy - textPainter.height / 2 - 60));

    // Subtitle text
    final subtitleTextPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
              text: '${numberFormat.format(pointsToNextTier)}\n',
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const TextSpan(
              text: 'TIER CREDITS\n',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const TextSpan(
              text: 'TO NEXT TIER',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
        style: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    subtitleTextPainter.layout();

    subtitleTextPainter.paint(
        canvas,
        Offset(center.dx - subtitleTextPainter.width / 2,
            center.dy + textPainter.height / 2 - 30));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';
import 'package:flutter_ticket_custom_clipper/utils/ticket_utils.dart';
import 'package:flutter_ticket_custom_clipper/widgets/ticket_content.dart';

/// Demonstrates a ticket widget using CustomPainter to draw shape and custom shadow effect.
///
/// This approach uses `CustomPainter` with `canvas.drawPath()` to create a
/// ticket-like widget with highly customizable shadow rendering.
///
/// Advantages:
/// - Allows precise control over shadow appearance (opacity, blur, and offset)
/// - Ability to create complex, multi-layered shadow effects
///
/// Limitations:
/// - Higher computational overhead compared to `canvas.drawShadow()` methods
/// - Less performance-efficient due to manual shadow drawing
/// - Expensive computation if blur effect is included
///
/// Best Used When:
/// - Precise, custom shadow effects are required
/// - Performance is not the primary concern
/// - Design demands unique shadow rendering techniques
class SolutionThreeTicket extends StatelessWidget {
  /// Creates a ticket widget using CustomPainter to draw shape and custom shadow effect.
  const SolutionThreeTicket({this.width = 320, this.height = 160, super.key});

  /// Width of the ticket
  final double width;

  /// Height of the ticket
  final double height;

  @override
  Widget build(BuildContext context) {
    debugPrint('#3 build Ticket');
    return CustomPaint(
      size: Size(width, height),
      painter: const ShapeAndBluryShadowPainter(),
      child: TicketContent(width: width, height: height),
    );
  }
}

/// A custom painter for drawing a shape and blury shadow.
/// Use drawPath() to draw custom shadow effects, such as blur.
class ShapeAndBluryShadowPainter extends CustomPainter {
  /// Creates a custom painter for drawing a shape and blury shadow.
  const ShapeAndBluryShadowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('#3 draw SHAPE and SHADOW');

    // Constants for ticket shape customization
    const concavePosition = 0.7; // Position of concave indent (70% from left)
    // Calculate concave radius based on ticket size
    // You can set a fixed value here if you ticket size is fixed
    final concaveRadius = TicketUtils.calculateConcaveRadius(
      width: size.width,
      height: size.height,
    );
    // Calculate corner radius based on ticket size
    // You can set a fixed value here if you ticket size is fixed
    final cornerRadius = TicketUtils.calculateCornerRadius(
      width: size.width,
      height: size.height,
    );

    final path =
        Path()
          // ## Draw left side of ticket
          ..moveTo(cornerRadius, 0)
          // Top-left corner
          ..quadraticBezierTo(0, 0, 0, cornerRadius)
          // Left edge
          ..lineTo(0, size.height - cornerRadius)
          // Bottom-left corner
          ..quadraticBezierTo(0, size.height, cornerRadius, size.height)
          // ## Draw bottom edge with concave indent
          // Bottom edge until concave
          ..lineTo(size.width * concavePosition, size.height)
          // Bottom concave curve
          ..arcToPoint(
            Offset(
              (size.width * concavePosition) + (concaveRadius * 2),
              size.height,
            ),
            radius: Radius.circular(concaveRadius),
          )
          // Remaining bottom edge
          ..lineTo(size.width - cornerRadius, size.height)
          // Bottom-right corner
          ..quadraticBezierTo(
            size.width,
            size.height,
            size.width,
            size.height - cornerRadius,
          )
          // ## Draw right side of ticket
          // Right Edge
          ..lineTo(size.width, cornerRadius)
          // Top-right corner
          ..quadraticBezierTo(size.width, 0, size.width - cornerRadius, 0)
          // Draw top edge with concave indent
          // Top edge until concave
          ..lineTo((size.width * concavePosition) + (concaveRadius * 2), 0)
          // Top concave curve
          ..arcToPoint(
            Offset(size.width * concavePosition, 0),
            radius: Radius.circular(concaveRadius),
          )
          // close the path (remaining top edge)
          ..close();

    // Draw shadow with blur effect
    final shadowPaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawPath(path.shift(const Offset(9, 4)), shadowPaint);

    // Draw shape
    final paint =
        Paint()
          ..color = Colors.lightGreen
          ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

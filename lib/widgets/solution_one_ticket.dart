import 'package:flutter/material.dart';
import 'package:flutter_ticket_custom_clipper/utils/ticket_utils.dart';
import 'package:flutter_ticket_custom_clipper/widgets/ticket_content.dart';

/// Demonstrates a ticket widget using CustomPainter with drawShadow() method.
///
/// This approach uses `CustomPainter` to draw both the ticket shape and its shadow
/// with high performance and minimal overhead. Basic shadow rendering using `canvas.drawShadow()`.
///
/// Advantages:
/// - Most optimized performance for basic shadow rendering
/// - Natural shadow effect with basic customization
///
/// Limitations:
/// - No direct support for image background clipping
/// - Shadow customization is restricted to built-in parameters of `drawShadow()`
///
/// Best Used When:
/// - Basic shadow is enough
/// - No need for image background clipping
/// - Require best-optimized performance
class SolutionOneTicket extends StatelessWidget {
  /// Creates a ticket widget using CustomPainter with drawShadow() method.
  const SolutionOneTicket({this.width = 320, this.height = 160, super.key});

  /// Width of the ticket
  final double width;

  /// Height of the ticket
  final double height;

  @override
  Widget build(BuildContext context) {
    debugPrint('#1 build Ticket');
    return CustomPaint(
      size: Size(width, height),
      painter: const ShapeAndShadowCustomPainter(),
      child: TicketContent(width: width, height: height),
    );
  }
}

/// A custom painter for drawing a shape and basic sahadow
class ShapeAndShadowCustomPainter extends CustomPainter {
  /// Creates a custom painter for drawing a shape and basic sahadow
  const ShapeAndShadowCustomPainter();
  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('#1 draw SHAPE and SHADOW');

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

    // Draw shadow
    // transparentOccluder is to tell whether the object casting the shadow is solid or a bit see-through.
    // set to true for see-through object, makes the shadow softer and lighter
    // set to false for solid object, makes the shadow darker and more defined
    canvas.drawShadow(path, Colors.black, 6, false);

    // Draw shape
    final paint =
        Paint()
          ..color = Colors.lightGreen
          ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

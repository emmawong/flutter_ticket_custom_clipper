import 'package:flutter/material.dart';
import 'package:flutter_ticket_custom_clipper/utils/ticket_utils.dart';
import 'package:flutter_ticket_custom_clipper/widgets/ticket_content.dart';

/// Demonstrates a ticket widget using Stack with separate CustomPainter and CustomClipper.
///
/// This approach uses a `Stack` with :
/// - `CustomPainter` for drawing basic shadow using `canvas.drawShadow()`
/// - `CustomClipper` for creating a precise ticket shape
///
/// Advantages:
/// - Allows image background within the ticket shape
/// - Decouples shadow and shape rendering
/// - Optimized shadow rendering using built-in `canvas.drawShadow()`
///
/// Limitations:
/// - Slightly more complex implementation compared to single-painter solutions
/// - Shadow customization is still limited to basic parameters
///
/// Best Used When:
/// - Need to clip an image or background within a ticket shape
/// - Want to maintain good rendering performance
/// - Basic shadow is enough (use `canvas.drawPath()` instead of `canvas.drawShadow()` if need custom shadow)
class SolutionFourTicket extends StatelessWidget {
  /// Create a ticket widget using Stack with separate CustomPainter and CustomClipper.
  const SolutionFourTicket({this.width = 320, this.height = 160, super.key});

  /// Width of the ticket
  final double width;

  /// Height of the ticket
  final double height;

  @override
  Widget build(BuildContext context) {
    debugPrint('#4 build Ticket');
    // use Stack instead of putting CustomPaint as a child underClipPath
    // because shadow may be clipped and not visible
    return Stack(
      children: [
        CustomPaint(size: Size(width, height), painter: TicketShadowPainter()),
        ClipPath(
          clipper: TicketShapeClipper(),
          child: TicketContent(
            width: width,
            height: height,
            withImageBackground: true,
          ),
        ),
      ],
    );
  }
}

/// A custom clipper for creating the shape of the ticket
class TicketShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint('#4 clip');

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

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// A custom painter for drawing a basic shadow by reusing the clipper path
class TicketShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('#4 draw SHADOW');
    final path = TicketShapeClipper().getClip(size);
    // transparentOccluder is to tell whether the object casting the shadow is solid or a bit see-through.
    // set to true for see-through object, makes the shadow softer and lighter
    // set to false for solid object, makes the shadow darker and more defined
    canvas.drawShadow(path, Colors.black, 6, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

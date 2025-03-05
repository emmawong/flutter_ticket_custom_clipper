import 'package:flutter/material.dart';
import 'package:flutter_ticket_custom_clipper/utils/ticket_utils.dart';
import 'package:flutter_ticket_custom_clipper/widgets/ticket_content.dart';

/// Demonstrates a ticket widget with a basic shadow using PhysicalShape and CustomClipper.
///
/// This approach uses `PhysicalShape` to create a ticket-like widget with basic shadow.
///
/// Advantages:
/// - Minimal code required for basic shadow rendering
/// - Easy-to-use built-in widget with optimized performance
/// - Natural shadow effect with basic customization
///
/// Limitations:
/// - No direct support for image background clipping
/// - Limited shadow customization (only color and elevation)
/// - Less optimized compared to `CustomPainter`
///
/// Best Used When:
/// - Basic shadow is enough
/// - No need for image background clipping
/// - Prefer minimal code and optimized performance
/// - Not require as optimized as `CustomPainter` in solution 1
class SolutionTwoTicket extends StatelessWidget {
  /// Creates a ticket widget with a PhysicalShape shadow.
  const SolutionTwoTicket({this.width = 320, this.height = 160, super.key});

  /// Width of the ticket
  final double width;

  /// Height of the ticket
  final double height;

  @override
  Widget build(BuildContext context) {
    debugPrint('#2 build Ticket');
    return PhysicalShape(
      clipper: TicketClipper(),
      color: Colors.lightGreen,
      elevation: 6,
      shadowColor: Colors.black87,
      child: TicketContent(width: width, height: height),
    );
  }
}

/// Custom clipper to create the shape of the ticket.
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint('#2 CLIP');

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
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

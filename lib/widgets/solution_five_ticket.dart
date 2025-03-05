import 'package:flutter/material.dart';
import 'package:flutter_ticket_custom_clipper/utils/ticket_utils.dart';
import 'package:flutter_ticket_custom_clipper/widgets/ticket_content.dart';

/// Demonstrates a ticket widget using CustomClipper with EvenOdd path clipping.
///
/// This approach uses `CustomClipper` with `PathFillType.evenOdd` to create
/// a ticket-like shape with minimal clipping path code. No shadow rendering.
///
/// Advantages:
/// - Most lightweight and performance-optimized solution
/// - Extremely simple implementation
/// - Supports image background clipping
///
/// Limitations:
/// - No built-in shadow support
/// - Complicated shape may not work with EvenOdd path clipping
///
/// Best Used When:
/// - No shadow is required
/// - Absolute minimal code is preferred
/// - Need to clip an image or background within a simple ticket shape
/// - Performance is a critical concern
class SolutionFiveTicket extends StatelessWidget {
  /// Demonstrates a ticket widget using CustomClipper with EvenOdd path clipping.
  const SolutionFiveTicket({this.width = 320, this.height = 160, super.key});

  /// Width of the ticket
  final double width;

  /// Height of the ticket
  final double height;

  @override
  Widget build(BuildContext context) {
    debugPrint('#5 build Ticket');
    return ClipPath(
      clipper: TicketShapeClipperEvenOdd(),
      child: TicketContent(
        width: width,
        height: height,
        withImageBackground: true,
      ),
    );
  }
}

/// A custom clipper for creating the shape of the ticket using even-odd technique
class TicketShapeClipperEvenOdd extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint('#5 CLIP');
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

    final outerPath =
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Radius.circular(cornerRadius),
          ),
        );

    // Define the concave indent at the bottom
    final bottomConcavePath =
        Path()..addOval(
          Rect.fromCircle(
            center: Offset(
              size.width * concavePosition + concaveRadius,
              size.height,
            ),
            radius: concaveRadius,
          ),
        );

    // Define the concave indent at the top
    final topConcavePath =
        Path()..addOval(
          Rect.fromCircle(
            center: Offset(size.width * concavePosition + concaveRadius, 0),
            radius: concaveRadius,
          ),
        );

    // Combine the paths by subtracting the concave indents from the main shape
    final clippedPath = Path.combine(
      PathOperation.difference,
      Path.combine(PathOperation.difference, outerPath, bottomConcavePath),
      topConcavePath,
    )..fillType = PathFillType.evenOdd;

    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

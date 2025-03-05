import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_ticket_custom_clipper/utils/ticket_utils.dart';
import 'package:flutter_ticket_custom_clipper/widgets/ticket_content.dart';

/// Demonstrates an animated ticket widget with dynamic shadow and hover effects.
///
/// This approach combines `Stack`, `CustomClipper`, `CustomPainter`, and `TweenAnimationBuilder`
/// to create the ticket shape with an animated shadow effects.
///
/// `CustomClipper` draws a static shape.
///
/// `CustomPainter` and `TweenAnimationBuilder` are for animated shadow effect.
///
/// Advantages:
/// - Smooth animation of shadow properties (opacity, blur)
/// - Decouples shadow and shape rendering
///
/// Key Animation Techniques:
/// - Dynamically adjusts shadow opacity and blur for CustomPainter
/// - Wrapped `CustomPaint` with `RepaintBoundary` the prevent the animataion from affecting parent widgets.
///
/// Limitations:
/// - Higher computational overhead due to animation
/// - Blur effect can be expensive to render
/// - More complex implementation compared to static solutions`
///
/// Best Used When:
/// - Need to create a dynamic animated shadow
/// - Performance is not the primary concern
class SolutionSixAnimatedTicket extends StatefulWidget {
  /// Creates a ticket widget with dynamic shadow and hover effects.
  const SolutionSixAnimatedTicket({
    this.width = 320,
    this.height = 160,
    super.key,
  });

  /// Width of the ticket
  final double width;

  /// Height of the ticket
  final double height;

  @override
  State<SolutionSixAnimatedTicket> createState() =>
      SolutionSixAnimatedTicketState();
}

/// Make state class public for animation state testing
class SolutionSixAnimatedTicketState extends State<SolutionSixAnimatedTicket> {
  final double _start = 0;
  double _end = 0;
  // Cache the path to avoid recalculating it
  late final Path _ticketPath;

  /// Getter to expose animation state for testing
  double get animationProgress => _end;

  double _scaleBlur(double factor) => 5.0 + (5.0 * factor);
  double _scaleOpacity(double factor) => 0.3 + (0.3 * factor);

  @override
  void initState() {
    _ticketPath = _createTicketPath(Size(widget.width, widget.height));
    super.initState();
  }

  void _triggerAnimation(bool activate) {
    setState(() {
      _end = activate ? 1.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('#6 build Ticket');

    final ticketContent = Stack(
      children: [
        // Shadow animation
        TweenAnimationBuilder(
          tween: Tween(begin: _start, end: _end),
          duration: const Duration(milliseconds: 200),
          builder: (_, value, _) {
            return RepaintBoundary(
              child: CustomPaint(
                size: Size(widget.width, widget.height),
                painter: TicketShadowPainter(
                  path: _ticketPath,
                  shadowBlur: _scaleBlur(value),
                  shadowColor: Colors.black.withValues(
                    alpha: _scaleOpacity(value),
                  ),
                ),
              ),
            );
          },
        ),
        // Shape layer - static and won't repaint
        ClipPath(
          clipper: TicketShapeClipper(path: _ticketPath),
          child: TicketContent(
            width: widget.width,
            height: widget.height,
            withImageBackground: true,
          ),
        ),
      ],
    );

    // **Detect gestures based on platform**
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      // Mobile (Android & iOS): Use GestureDetector for tap effects
      return GestureDetector(
        onTapDown: (_) => _triggerAnimation(true),
        onTapUp: (_) => _triggerAnimation(false),
        child: ticketContent,
      );
    } else {
      // Web & Desktop: Use MouseRegion for hover effect
      return MouseRegion(
        onEnter: (_) => _triggerAnimation(true),
        onExit: (_) => _triggerAnimation(false),
        child: ticketContent,
      );
    }
  }

  // create the ticket path
  static Path _createTicketPath(Size size) {
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
}

/// This painter draw customized shadow effects using `drawPath()`.
///
/// `path` is the path to draw the shadow.
///
/// `shadowBlur` is the blur value of the shadow.
///
/// `shadowColor` is the color of the shadow.
class TicketShadowPainter extends CustomPainter {
  /// Creates a custom painter for drawing a custom shadow effects by reusing the clipper path.
  TicketShadowPainter({
    required this.path,
    required this.shadowBlur,
    required this.shadowColor,
  });

  /// The path to draw the shadow.
  final Path path;

  /// The blur value of the shadow.
  final double shadowBlur;

  /// The color of the shadow.
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('#6 draw SHADOW');

    final shadowPaint =
        Paint()
          ..color = shadowColor
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);

    // Draw shadow slightly offset for natural effect
    canvas.drawPath(path.shift(const Offset(4, 4)), shadowPaint);
  }

  @override
  bool shouldRepaint(covariant TicketShadowPainter oldDelegate) {
    return oldDelegate.shadowBlur != shadowBlur ||
        oldDelegate.shadowColor != shadowColor;
  }
}

/// This clipper will be used to clip the ticket shape by reusing the cached path.
///
/// `path` is the path to clip the ticket shape.
class TicketShapeClipper extends CustomClipper<Path> {
  /// Creates a custom clipper for the ticket shape by reusing the cached path.
  TicketShapeClipper({required this.path});

  /// The path to clip the ticket shape.
  final Path path;

  @override
  Path getClip(Size size) {
    debugPrint('#6 CLIP');
    // return the cached path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

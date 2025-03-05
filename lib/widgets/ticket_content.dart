import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ticket_custom_clipper/utils/ticket_utils.dart';

/// Widget to display the content of the ticket.
class TicketContent extends StatelessWidget {
  /// Creates a widget to display the content of the ticket.
  ///
  /// optional `withImageBackground` parameter to enable a background image, default `false`.
  ///
  /// Default widget size is 320x160. You can change the size by passing in the `width` and `height` parameters.
  const TicketContent({
    super.key,
    this.width = 320,
    this.height = 160,
    this.withImageBackground = false,
  });

  /// The width and height of the ticket.
  final double width;

  /// The width and height of the ticket.
  final double height;

  /// Whether to display an image background.
  final bool withImageBackground;

  @override
  Widget build(BuildContext context) {
    debugPrint('build content');

    final ticketSize = TicketUtils.getTicketSizeType(
      width: width,
      height: height,
    );

    final ticketConcaveRadius = TicketUtils.calculateConcaveRadius(
      width: width,
      height: height,
    );

    final horizontalPadding = switch (ticketSize) {
      TicketSize.extraSmall => 4.0,
      TicketSize.small => 8.0,
      TicketSize.normal => 16.0,
    };
    final contentFontSize = switch (ticketSize) {
      TicketSize.extraSmall => 8.0,
      TicketSize.small => 12.0,
      TicketSize.normal => 18.0,
    };
    final bardcodeNumFontSize = switch (ticketSize) {
      TicketSize.extraSmall => 4.0,
      TicketSize.small => 6.0,
      TicketSize.normal => 9.0,
    };
    return Container(
      padding: EdgeInsets.symmetric(vertical: ticketConcaveRadius),
      width: width,
      height: height,
      decoration:
          withImageBackground
              ? const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/movie_poster.jpg'),
                  fit: BoxFit.cover,
                ),
              )
              : null,
      child: Row(
        children: [
          // Content (Left of the Dotted Line)
          Expanded(
            flex: 7,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Center(
                child: Text(
                  'Movie Night 🎬',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: contentFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ),
          // Dotted Line and Barcode
          Expanded(
            flex: 3,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DottedLine(
                  width: ticketConcaveRadius * 2,
                  height: height - ticketConcaveRadius * 2.0,
                  color: Colors.white,
                  offset: ticketConcaveRadius,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (ticketSize != TicketSize.extraSmall)
                        BarcodeNumber(
                          text: '12345678',
                          bardcodeNumFontSize: bardcodeNumFontSize,
                        ),
                      Flexible(
                        child: FakeBarcode(
                          width: width * 0.3 * 0.3,
                          height: height,
                        ),
                      ),
                      Flexible(
                        // As a right padding but can shrink to zero
                        child: SizedBox(width: horizontalPadding),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A widget that displays a fake barcode number
class BarcodeNumber extends StatelessWidget {
  /// Creates a widget that displays a fake barcode number
  const BarcodeNumber({
    required this.text,
    required this.bardcodeNumFontSize,
    super.key,
  });

  /// The text to display
  final double bardcodeNumFontSize;

  /// The font size of the text
  final String text;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: bardcodeNumFontSize),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// A widget that displays a dotted line
class DottedLine extends StatelessWidget {
  /// Creates widget that displays a dotted line
  const DottedLine({
    required this.width,
    required this.height,
    this.color = Colors.black,
    this.offset = 0,
    super.key,
  });

  /// The width of the dotted line
  final double width;

  /// The height of the dotted line
  final double height;

  /// The color of the dotted line
  final Color color;

  /// The offset of the dotted line
  final double offset;

  @override
  Widget build(BuildContext context) {
    debugPrint('# build DOTTED LINE');
    return SizedBox(
      width: width,
      child: CustomPaint(
        size: Size(2, height),
        painter: DottedLinePainter(color: color, offsetX: offset),
      ),
    );
  }
}

/// A widget that displays a fake barcode.
class FakeBarcode extends StatelessWidget {
  /// Creates a widget that displays a fake barcode.
  const FakeBarcode({required this.width, required this.height, super.key});

  /// The width of the fake barcode.
  final double width;

  /// The height of the fake barcode.
  final double height;

  @override
  Widget build(BuildContext context) {
    debugPrint('# build FAKE BARCODE');
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(width, height),
        painter: FakeBarcodePainter(),
      ),
    );
  }
}

/// A custom painter for drawing a dotted line
class DottedLinePainter extends CustomPainter {
  /// Creates a custom painter for drawing a dotted line
  ///
  /// [color] The color of the line
  /// [offsetX] The x-axis offset start drawing the line
  const DottedLinePainter({this.color = Colors.black, this.offsetX = 0});

  /// The color of the line
  final Color color;

  /// The x-axis offset start drawing the line
  final double offsetX;

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('# draw dotted line');
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    const dashHeight = 3;
    const dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      var endY = startY + dashHeight;
      // Ensure the line doesn't go beyond the height of the canvas
      if (endY > size.height) {
        endY = size.height;
      }
      canvas.drawLine(Offset(offsetX, startY), Offset(offsetX, endY), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// A custom painter for drawing a fake barcode
class FakeBarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('# draw barcode');
    final rand = Random();
    final verticalMargin = size.height * 0.05;
    const horizontalMargin = 2.0;
    final maxY = size.height - verticalMargin;
    var startY = verticalMargin;

    // Draw full white background
    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Detect if running in a test environment
    final isTesting = Platform.environment.containsKey('FLUTTER_TEST');
    if (isTesting) {
      return;
    }

    // Draw barcode lines
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth =
              size.width -
              (horizontalMargin * 2) // Reasonable line width
          ..style = PaintingStyle.stroke;

    while (startY < maxY) {
      final randomHeight = rand.nextDouble() * 1.8;
      final randomSpace = rand.nextDouble() * 1.8;
      canvas.drawLine(
        Offset(size.width / 2, startY), // Start from x = 2 for a margin
        Offset(size.width / 2, startY + randomHeight), // Draw full width
        paint,
      );
      startY += randomHeight + randomSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

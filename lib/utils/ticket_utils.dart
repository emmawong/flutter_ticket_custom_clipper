import 'dart:math';

/// Represents different ticket size categories
enum TicketSize {
  /// Ticket is too small to render normally
  extraSmall,

  /// Ticket is small but not extra small
  small,

  /// Ticket is of normal or large size
  normal,
}

/// Utility class for ticket-related calculations and helper methods
class TicketUtils {
  /// Prevents instantiation of this utility class
  const TicketUtils._();

  /// Minimum supported width for ticket rendering
  static const double minWidthSupport = 100;

  /// Minimum supported height for ticket rendering
  static const double minHeightSupport = 50;

  /// width boundary for a small ticket
  static const double smallTicketWidth = 200;

  /// Determines the size category of a ticket
  ///
  /// [width] The width of the ticket
  /// [height] The height of the ticket
  ///
  /// Returns the [TicketSize] based on ticket dimensions
  static TicketSize getTicketSizeType({
    required double width,
    required double height,
  }) {
    if (width < minWidthSupport || height < minHeightSupport) {
      return TicketSize.extraSmall;
    }

    if (width < smallTicketWidth) {
      return TicketSize.small;
    }

    return TicketSize.normal;
  }

  /// Convenience methods for quick size category checks
  static bool isExtraSmallTicket({
    required double width,
    required double height,
  }) {
    return getTicketSizeType(width: width, height: height) ==
        TicketSize.extraSmall;
  }

  /// Checks if the ticket is small
  static bool isSmallTicket({required double width, required double height}) {
    return getTicketSizeType(width: width, height: height) == TicketSize.small;
  }

  /// Calculates a dynamic ticket concave radius based on widget dimensions
  ///
  /// [width] The width of the widget
  /// [height] The height of the widget
  ///
  /// Returns a calculated concave radius that scales with widget size
  static double calculateConcaveRadius({
    required double width,
    required double height,
  }) {
    final radius = min(width * 0.04, height * 0.1);
    return radius >= 16 ? 16 : radius;
  }

  /// Calculates a dynamic corner radius based on widget dimensions
  ///
  /// [width] The width of the widget
  /// [height] The height of the widget
  ///
  /// Returns a calculated corner radius that scales with widget size
  static double calculateCornerRadius({
    required double width,
    required double height,
  }) {
    final ticketSize = getTicketSizeType(width: width, height: height);
    switch (ticketSize) {
      case TicketSize.extraSmall:
        return 4;
      case TicketSize.small:
        return 10;
      case TicketSize.normal:
        return 16;
    }
  }
}

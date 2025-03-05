import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ticket_custom_clipper/widgets/solution_one_ticket.dart';

import '../test_constants.dart';

void main() {
  group('SolutionOneTicket Widget Tests', () {
    testWidgets('verify CustomPaint width and height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SolutionOneTicket(
                width: TestConstants.extraSmallSize.$1,
                height: TestConstants.extraSmallSize.$2,
              ),
            ),
          ),
        ),
      );

      // Find the CustomPaint widget
      final ticketFinder = find.byType(SolutionOneTicket);
      final customPaintFinder =
          find
              .descendant(of: ticketFinder, matching: find.byType(CustomPaint))
              .first;

      // Get the widget's size
      final widgetSize = tester.getSize(customPaintFinder);

      // Validate width and height
      expect(
        widgetSize.width,
        equals(TestConstants.extraSmallSize.$1),
        reason: 'Width does not match',
      );
      expect(
        widgetSize.height,
        equals(TestConstants.extraSmallSize.$2),
        reason: 'Height does not match',
      );
    });
  });

  group('SolutionOneTicket Golden Tests', () {
    testWidgets('renders default SolutionOneTicket', (
      WidgetTester tester,
    ) async {
      // set surface size so the golden file is not too large
      await tester.binding.setSurfaceSize(TestConstants.goldenTestSurfaceSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: SolutionOneTicket())),
        ),
      );

      await expectLater(
        find.byType(SolutionOneTicket),
        matchesGoldenFile('goldens/solution_one_ticket_default.png'),
        reason: 'SolutionOneTicket with default size does not match golden',
      );
    });

    testWidgets('renders SolutionOneTicket with custom size', (
      WidgetTester tester,
    ) async {
      // set surface size so the golden file is not too large
      await tester.binding.setSurfaceSize(TestConstants.goldenTestSurfaceSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SolutionOneTicket(
                width: TestConstants.extraSmallSize.$1,
                height: TestConstants.extraSmallSize.$2,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(SolutionOneTicket),
        matchesGoldenFile('goldens/solution_one_ticket_small_size.png'),
        reason: 'SolutionOneTicket with custom size does not match golden',
      );
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ticket_custom_clipper/widgets/solution_three_ticket.dart';

import '../test_constants.dart';

void main() {
  group('SolutionThreeTicket Widget Tests', () {
    testWidgets('verify CustomPaint width and height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SolutionThreeTicket(
                width: TestConstants.extraSmallSize.$1,
                height: TestConstants.extraSmallSize.$2,
              ),
            ),
          ),
        ),
      );

      // Find the CustomPaint widget
      final ticketFinder = find.byType(SolutionThreeTicket);
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

  group('SolutionThreeTicket Golden Tests', () {
    testWidgets('renders default SolutionThreeTicket', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(TestConstants.goldenTestSurfaceSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: SolutionThreeTicket())),
        ),
      );

      await expectLater(
        find.byType(SolutionThreeTicket),
        matchesGoldenFile('goldens/solution_three_ticket_default.png'),
        reason: 'SolutionThreeTicket with custom size does not match golden',
      );
    });

    testWidgets('renders SolutionThreeTicket with custom size', (
      WidgetTester tester,
    ) async {
      // set surface size so the golden file is not too large
      await tester.binding.setSurfaceSize(TestConstants.goldenTestSurfaceSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SolutionThreeTicket(
                width: TestConstants.extraSmallSize.$1,
                height: TestConstants.extraSmallSize.$2,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(SolutionThreeTicket),
        matchesGoldenFile('goldens/solution_three_ticket_small_size.png'),
        reason: 'SolutionThreeTicket with custom size does not match golden',
      );
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ticket_custom_clipper/widgets/solution_five_ticket.dart';

import '../test_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SolutionFiveTicket Widget Tests', () {
    testWidgets('verify CustomPaint width and height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SolutionFiveTicket(
                width: TestConstants.extraSmallSize.$1,
                height: TestConstants.extraSmallSize.$2,
              ),
            ),
          ),
        ),
      );

      // Find the CustomPaint widget
      final ticketFinder = find.byType(SolutionFiveTicket);
      final clipPathFinder =
          find
              .descendant(of: ticketFinder, matching: find.byType(ClipPath))
              .first;

      // Get the widget's size
      final widgetSize = tester.getSize(clipPathFinder);

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

  group('SolutionFiveTicket Golden Tests', () {
    testWidgets('renders default SolutionFiveTicket', (
      WidgetTester tester,
    ) async {
      // set surface size so the golden file is not too large
      await tester.binding.setSurfaceSize(TestConstants.goldenTestSurfaceSize);

      await tester.runAsync(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: Center(child: SolutionFiveTicket())),
          ),
        );
        // load the asset image before rendering the golden
        await precacheImage(
          const AssetImage('assets/movie_poster.jpg'),
          tester.element(find.byType(SolutionFiveTicket)),
        );
        await tester.pumpAndSettle();
      });

      await expectLater(
        find.byType(SolutionFiveTicket),
        matchesGoldenFile('goldens/solution_five_ticket_default.png'),
        reason: 'SolutionFiveTicket with default size does not match golden',
      );
    });

    testWidgets('renders SolutionFiveTicket with custom size', (
      WidgetTester tester,
    ) async {
      // set surface size so the golden file is not too large
      await tester.binding.setSurfaceSize(TestConstants.goldenTestSurfaceSize);

      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SolutionFiveTicket(
                  width: TestConstants.extraSmallSize.$1,
                  height: TestConstants.extraSmallSize.$2,
                ),
              ),
            ),
          ),
        );
        // load the asset image before rendering the golden
        await precacheImage(
          const AssetImage('assets/movie_poster.jpg'),
          tester.element(find.byType(SolutionFiveTicket)),
        );
        await tester.pumpAndSettle();
      });

      await expectLater(
        find.byType(SolutionFiveTicket),
        matchesGoldenFile('goldens/solution_five_ticket_small_size.png'),
        reason: 'SolutionFiveTicket with custom size does not match golden',
      );
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ticket_custom_clipper/widgets/solution_four_ticket.dart';

import '../test_constants.dart';

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized();
  group('SolutionFourTicket Widget Tests', () {
    testWidgets('verify CustomPaint width and height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SolutionFourTicket(
                width: TestConstants.extraSmallSize.$1,
                height: TestConstants.extraSmallSize.$2,
              ),
            ),
          ),
        ),
      );

      // Find the CustomPaint widget
      final ticketFinder = find.byType(SolutionFourTicket);
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

  group('SolutionFourTicket Golden Tests', () {
    testWidgets('renders default SolutionFourTicket', (
      WidgetTester tester,
    ) async {
      // set surface size so the golden file is not too large
      await tester.binding.setSurfaceSize(TestConstants.goldenTestSurfaceSize);

      await tester.runAsync(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: Center(child: SolutionFourTicket())),
          ),
        ); // load the asset image before rendering the golden
        await precacheImage(
          const AssetImage('assets/movie_poster.jpg'),
          tester.element(find.byType(SolutionFourTicket)),
        );
        await tester.pumpAndSettle();
      });

      await expectLater(
        find.byType(SolutionFourTicket),
        matchesGoldenFile('goldens/solution_four_ticket_default.png'),
        reason: 'SolutionFourTicket with default size does not match golden',
      );
    });

    testWidgets('renders SolutionFourTicket with custom size', (
      WidgetTester tester,
    ) async {
      // set surface size so the golden file is not too large
      await tester.binding.setSurfaceSize(TestConstants.goldenTestSurfaceSize);

      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SolutionFourTicket(
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
          tester.element(find.byType(SolutionFourTicket)),
        );
        await tester.pumpAndSettle();
      });

      await expectLater(
        find.byType(SolutionFourTicket),
        matchesGoldenFile('goldens/solution_four_ticket_small_size.png'),
        reason: 'SolutionFourTicket with custom size does not match golden',
      );
    });
  });
}

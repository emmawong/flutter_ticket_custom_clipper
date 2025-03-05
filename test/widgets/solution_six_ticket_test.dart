import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ticket_custom_clipper/widgets/solution_six_animated_ticket.dart';

import '../test_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SolutionSixAnimatedTicket Widget Tests', () {
    testWidgets('verify CustomPaint width and height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SolutionSixAnimatedTicket(
                width: TestConstants.extraSmallSize.$1,
                height: TestConstants.extraSmallSize.$2,
              ),
            ),
          ),
        ),
      );

      // Find the CustomPaint widget
      final ticketFinder = find.byType(SolutionSixAnimatedTicket);
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

    testWidgets('animates shadow on hover', (WidgetTester tester) async {
      // Override platform to Android so GestureDetector is used
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SolutionSixAnimatedTicket())),
      );

      final ticketFinder = find.byType(SolutionSixAnimatedTicket);

      // Simulate mouse enter (hover)
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(ticketFinder));
      await tester.pumpAndSettle();

      // Expect shadow animation triggered (check internal state changes)
      final ticketState = tester.state<SolutionSixAnimatedTicketState>(
        find.byType(SolutionSixAnimatedTicket),
      );
      // Shadow should be fully visible
      expect(
        ticketState.animationProgress,
        equals(1.0),
        reason: 'Animation not started when hovering',
      );

      // Simulate mouse exit
      await gesture.moveTo(const Offset(-1, -1));
      await tester.pumpAndSettle();

      // Expect shadow animation to reset
      expect(
        ticketState.animationProgress,
        equals(0.0),
        reason: 'Animation not ended when hover ended',
      );

      // Reset platform override after test
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('animates shadow on tap for mobile', (
      WidgetTester tester,
    ) async {
      // Override platform to Android so GestureDetector is used
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: SolutionSixAnimatedTicket())),
        ),
      );

      // Find the GestureDetector inside the widget
      final gestureDetector = find.byType(GestureDetector);
      expect(gestureDetector, findsOneWidget);

      // Start a long press gesture (tap down but not up yet)
      final gesture = await tester.startGesture(
        tester.getCenter(gestureDetector),
      );
      await tester.pump(); // Let the UI reflect the press

      // Verify that the animation has started
      final ticketState = tester.state<SolutionSixAnimatedTicketState>(
        find.byType(SolutionSixAnimatedTicket),
      );
      expect(
        ticketState.animationProgress,
        1.0,
        reason: 'Animation not started when tapping',
      );

      // Release the tap
      await gesture.up();
      await tester.pumpAndSettle();

      // Verify that the animation has ended
      expect(
        ticketState.animationProgress,
        0.0,
        reason: 'Animation not ended when tapped up',
      );

      // Reset platform override after test
      debugDefaultTargetPlatformOverride = null;
    });
  });

  group('SolutionSixAnimatedTicket Golden Tests', () {
    testWidgets('renders default SolutionSixAnimatedTicket', (
      WidgetTester tester,
    ) async {
      // set surface size so the golden file is not too large
      await tester.binding.setSurfaceSize(TestConstants.goldenTestSurfaceSize);

      await tester.runAsync(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: Center(child: SolutionSixAnimatedTicket())),
          ),
        );
        // load the asset image before rendering the golden
        await precacheImage(
          const AssetImage('assets/movie_poster.jpg'),
          tester.element(find.byType(SolutionSixAnimatedTicket)),
        );
        await tester.pumpAndSettle();
      });

      await expectLater(
        find.byType(SolutionSixAnimatedTicket),
        matchesGoldenFile('goldens/solution_six_animated_ticket_default.png'),
        reason: 'SolutionSixAnimatedTicket default does not match golden',
      );
    });

    testWidgets('renders SolutionSixAnimatedTicket with custom size', (
      WidgetTester tester,
    ) async {
      // set surface size so the golden file is not too large
      await tester.binding.setSurfaceSize(TestConstants.goldenTestSurfaceSize);

      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SolutionSixAnimatedTicket(
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
          tester.element(find.byType(SolutionSixAnimatedTicket)),
        );
        await tester.pumpAndSettle();
      });

      await expectLater(
        find.byType(SolutionSixAnimatedTicket),
        matchesGoldenFile(
          'goldens/solution_six_animated_ticket_small_size.png',
        ),
        reason:
            'SolutionSixAnimatedTicket with custom size does not match golden',
      );
    });
  });
}

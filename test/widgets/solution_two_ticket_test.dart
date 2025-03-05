import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ticket_custom_clipper/widgets/solution_two_ticket.dart';

import '../test_constants.dart';

void main() {
  group('SolutionTwoTicket Widget Tests', () {
    testWidgets('verify PhysicalShape width and height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SolutionTwoTicket(
                width: TestConstants.extraSmallSize.$1,
                height: TestConstants.extraSmallSize.$2,
              ),
            ),
          ),
        ),
      );

      // Find the PhysicalShape widget
      final shapeFinder = find.byType(PhysicalShape);

      // Get the actual size of PhysicalShape
      final shapeSize = tester.getSize(shapeFinder);

      // Validate width and height
      expect(
        shapeSize.width,
        equals(TestConstants.extraSmallSize.$1),
        reason: 'Width does not match',
      );
      expect(
        shapeSize.height,
        equals(TestConstants.extraSmallSize.$2),
        reason: 'Height does not match',
      );
    });
  });

  group('SolutionTwoTicket Golden Tests', () {
    testWidgets('renders default SolutionTwoTicket', (
      WidgetTester tester,
    ) async {
      // set surface size so the golden file is not too large
      await tester.binding.setSurfaceSize(TestConstants.goldenTestSurfaceSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: SolutionTwoTicket())),
        ),
      );

      await expectLater(
        find.byType(SolutionTwoTicket),
        matchesGoldenFile('goldens/solution_two_ticket_default.png'),
        reason: 'SolutionTwoTicket with default size does not match golden',
      );
    });

    testWidgets('renders SolutionTwoTicket with custom size', (
      WidgetTester tester,
    ) async {
      // set surface size so the golden file is not too large
      await tester.binding.setSurfaceSize(TestConstants.goldenTestSurfaceSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SolutionTwoTicket(
                width: TestConstants.extraSmallSize.$1,
                height: TestConstants.extraSmallSize.$2,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(SolutionTwoTicket),
        matchesGoldenFile('goldens/solution_two_ticket_small_size.png'),
        reason: 'SolutionTwoTicket with custom size does not match golden',
      );
    });
  });
}

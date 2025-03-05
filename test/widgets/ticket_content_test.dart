import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ticket_custom_clipper/widgets/ticket_content.dart';

import '../test_constants.dart';

void main() {
  group('TicketContent Widget Tests', () {
    testWidgets('renders with default parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: TicketContent())),
      );

      // Verify basic structure
      final ticketContentFinder = find.byType(TicketContent);
      expect(
        ticketContentFinder,
        findsOneWidget,
        reason: 'TicketContent not found',
      );
      expect(
        find.text('Movie Night 🎬'),
        findsOneWidget,
        reason: 'Text Movie Night not found',
      );
      expect(
        find.byType(DottedLine),
        findsOneWidget,
        reason: 'Dotted Line not found',
      );
      expect(
        find.byType(FakeBarcode),
        findsOneWidget,
        reason: 'Barcode not found',
      );
      expect(
        find.byType(BarcodeNumber),
        findsOneWidget,
        reason: 'BarcodeNumber not found',
      );

      // Verify default dimensions
      final container = tester.widget<Container>(find.byType(Container));
      expect(
        container.constraints?.maxWidth,
        320,
        reason: 'Container width does not match default value',
      );
      expect(
        container.constraints?.maxHeight,
        160,
        reason: 'Container height does not match default value',
      );
    });

    testWidgets('renders with custom size', (WidgetTester tester) async {
      const double customWidth = 400;
      const double customHeight = 200;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TicketContent(width: customWidth, height: customHeight),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(
        container.constraints?.maxWidth,
        customWidth,
        reason: 'Container width does not match custom size',
      );
      expect(
        container.constraints?.maxHeight,
        customHeight,
        reason: 'Container height does not match custom size',
      );
    });

    testWidgets('renders with image background when enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: TicketContent(withImageBackground: true)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isNotNull, reason: 'Decoration is null');
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.image, isNotNull, reason: 'Decoration Image is null');
      expect(
        decoration.image!.image,
        isA<AssetImage>(),
        reason: 'Decoration Image is not an AssetImage',
      );
    });

    testWidgets('font sizes adapts to extra small size', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketContent(
              // gloden test width test cases: 110 full, 70 2 lines, 50 ellipsis
              width: TestConstants.extraSmallSize.$1,
              height: TestConstants.extraSmallSize.$2,
            ),
          ),
        ),
      );

      verifyTicketContentFontSizes(tester, contentTypeFontSize: 8);
      // barcode number is not visible for extra small size
      verifyBarcodeNumberFontSizes(tester, barcodeNumFontSize: null);
      verifyDottedLineAndBarcodeVisibility(tester);
    });

    testWidgets('font sizes adapts to small size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketContent(
              width: TestConstants.smallSize.$1,
              height: TestConstants.smallSize.$2,
            ),
          ),
        ),
      );

      verifyTicketContentFontSizes(tester, contentTypeFontSize: 12);
      verifyBarcodeNumberFontSizes(tester, barcodeNumFontSize: 6);
      verifyDottedLineAndBarcodeVisibility(tester);
    });

    testWidgets('font sizes adapts to normal size', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketContent(
              width: TestConstants.normalSize.$1,
              height: TestConstants.normalSize.$2,
            ),
          ),
        ),
      );

      verifyTicketContentFontSizes(tester, contentTypeFontSize: 18);
      verifyBarcodeNumberFontSizes(tester, barcodeNumFontSize: 9);
      verifyDottedLineAndBarcodeVisibility(tester);
    });
  });

  testWidgets('padding adapts to extra small size', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TicketContent(
            width: TestConstants.extraSmallSize.$1,
            height: TestConstants.extraSmallSize.$2,
          ),
        ),
      ),
    );

    // calculateConcaveRadius
    // min(90.0 * 0.04, 40.0 * 0.1) = 3.6
    verifyContainerVerticalPadding(tester, 3.6);
    verifyContentHorizontalPadding(tester, 4);
  });

  testWidgets('padding adapts to small size', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TicketContent(
            width: TestConstants.smallSize.$1,
            height: TestConstants.smallSize.$2,
          ),
        ),
      ),
    );

    // calculateConcaveRadius
    // min(190.0 * 0.04, 80.0 * 0.1) = 7.6
    verifyContainerVerticalPadding(tester, 7.6);
    verifyContentHorizontalPadding(tester, 8);
  });

  testWidgets('padding adapts to normal size', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TicketContent(
            width: TestConstants.normalSize.$1,
            height: TestConstants.normalSize.$2,
          ),
        ),
      ),
    );

    // calculateConcaveRadius
    // min(290.0 * 0.04, 120.0 * 0.1) = 11.6
    verifyContainerVerticalPadding(tester, 11.6);
    verifyContentHorizontalPadding(tester, 16);
  });
}

// Helper function placed before the main() function
void verifyTicketContentFontSizes(
  WidgetTester tester, {
  required double contentTypeFontSize,
}) {
  // Verify content text is found
  final textWidgetFinder = find.text('Movie Night 🎬');
  expect(textWidgetFinder, findsOneWidget, reason: 'Content Text not found');
  // Verify text style for content text
  expect(
    tester.widget<Text>(textWidgetFinder).style?.fontSize,
    contentTypeFontSize,
    reason: 'Content Text font size is incorrect',
  );
}

void verifyBarcodeNumberFontSizes(
  WidgetTester tester, {
  required double? barcodeNumFontSize,
}) {
  // Verify barcode number text visibility
  final barcodeNumberWidgetFinder = find.byType(BarcodeNumber);
  if (barcodeNumFontSize != null) {
    expect(
      barcodeNumberWidgetFinder,
      findsOneWidget,
      reason: 'BarcodeNumber not found',
    );
    // validate barcode number text font size
    final barcodNumberTextFinder = find.descendant(
      of: barcodeNumberWidgetFinder,
      matching: find.byType(Text),
    );
    expect(
      tester.widget<Text>(barcodNumberTextFinder).style?.fontSize,
      barcodeNumFontSize,
      reason: 'BarcodeNumber Text font size is incorrect',
    );
  } else {
    // When barcodeNumFontSize is null, BarcodeNumber should not be visible
    expect(
      barcodeNumberWidgetFinder,
      findsNothing,
      reason: 'BarcodeNumber should not be visible',
    );
  }
}

void verifyDottedLineAndBarcodeVisibility(WidgetTester tester) {
  // Verify dotted line is found
  expect(
    find.byType(DottedLine),
    findsOneWidget,
    reason: 'Dotted Line not found',
  );

  // Verify barcode is found
  expect(find.byType(FakeBarcode), findsOneWidget, reason: 'Barcode not found');
}

void verifyContainerVerticalPadding(WidgetTester tester, double paddingValue) {
  // Find vertical padding in Container widget
  final container = tester.widget<Container>(find.byType(Container));
  expect(
    container.padding.toString(),
    equals(EdgeInsets.symmetric(vertical: paddingValue).toString()),
    reason: 'Container verticalpadding is incorrect',
  );
}

void verifyContentHorizontalPadding(WidgetTester tester, double paddingValue) {
  // Find the Row
  final rowFinder = find.byType(Row);
  // Find the first child of the Row which is Expanded widget
  final firstExpandedFinder =
      find.descendant(of: rowFinder, matching: find.byType(Expanded)).first;
  final paddingFinder = find.descendant(
    of: firstExpandedFinder,
    matching: find.byType(Padding),
  );
  expect(
    tester.widget<Padding>(paddingFinder).padding.toString(),
    equals(EdgeInsets.symmetric(horizontal: paddingValue).toString()),
    reason: 'Content horizontal Padding is incorrect',
  );
}

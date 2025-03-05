import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ticket_custom_clipper/utils/ticket_utils.dart';

import 'test_constants.dart';

void main() {
  group('TicketUtils', () {
    group('getTicketSizeType', () {
      test('correctly categorizes extra small tickets', () {
        // Extra Small Ticket
        // Width < 100 or Height < 50
        final testCases = [
          // both width and height are less than lower bound of extra small ticket size
          (50.0, 25.0),
          // only width is less than lower bound of extra small ticket size
          (50.0, 200.0),
          // only height is less than lower bound of extra small ticket size
          (300.0, 25.0),
          // decimal values close to the lower bound
          (99.9, 49.9),
        ];

        for (final testCase in testCases) {
          final sizeType = TicketUtils.getTicketSizeType(
            width: testCase.$1,
            height: testCase.$2,
          );

          expect(
            sizeType,
            TicketSize.extraSmall,
            reason: 'Failed for width: ${testCase.$1}, height: ${testCase.$2}',
          );
        }
      });

      test('correctly categorizes small tickets', () {
        // Small Ticket
        // Width >= 100 and < 200
        final testCases = [
          // width and height within small ticket range
          (150.0, 75.0),
          // width at the lower bound of small ticket size
          (100.0, 50.0),
          // decimal values close to the upper bound
          (199.9, 100.0),
        ];

        for (final testCase in testCases) {
          final sizeType = TicketUtils.getTicketSizeType(
            width: testCase.$1,
            height: testCase.$2,
          );

          expect(
            sizeType,
            TicketSize.small,
            reason: 'Failed for width: ${testCase.$1}, height: ${testCase.$2}',
          );
        }
      });

      test('correctly categorizes normal tickets', () {
        // Normal Ticket
        // Width >= 200
        final testCases = [
          // width equal to the boundary of normal ticket size
          (200.0, 150.0),
          // standard width and standard height
          (300.0, 150.0),
          // standard width and small height
          (300.0, 60.0),
          // extra large width and height
          (2000.0, 1600.0),
        ];

        for (final testCase in testCases) {
          final sizeType = TicketUtils.getTicketSizeType(
            width: testCase.$1,
            height: testCase.$2,
          );

          expect(
            sizeType,
            TicketSize.normal,
            reason: 'Failed for width: ${testCase.$1}, height: ${testCase.$2}',
          );
        }
      });
    });
    group('calculateConcaveRadius', () {
      test(
        'returns concave radius smaller than 16 for appropriate input sizes',
        () {
          // Group Smaller than 16
          final testCases = [
            // Case: width * 0.04 is smaller than height * 0.1
            // and the smaller one is smaller than 16
            (320.0, 160.0, 12.8),
            // Case: height * 0.1 is smaller than width * 0.04
            // and the smaller one is smaller than 16
            (160.0, 320.0, 6.4),
            // Case: width * 0.04 and height * 0.1 are the same
            // and the smaller one is smaller than 16
            (320.0, 128.0, 12.8),
            // Case: extreme small size
            (10.0, 5.0, 0.4),
          ];

          for (final testCase in testCases) {
            final radius = TicketUtils.calculateConcaveRadius(
              width: testCase.$1,
              height: testCase.$2,
            );

            expect(
              radius,
              testCase.$3,
              reason:
                  'Failed for width: ${testCase.$1}, height: ${testCase.$2}',
            );
          }
        },
      );

      test('returns concave radius equal to 16 for specific input sizes', () {
        // Group Equal to 16
        final testCases = [
          // Case: width * 0.04 is smaller than height * 0.1
          // and the smaller one is equal to 16
          (400.0, 170.0),
          // Case: height * 0.1 is smaller than width * 0.04
          // and the smaller one is equal to 16
          (425.0, 160.0),
          // Case: width * 0.04 and height * 0.1 are the same
          // and the smaller one is equal to 16
          (400.0, 160.0),
        ];

        for (final testCase in testCases) {
          final radius = TicketUtils.calculateConcaveRadius(
            width: testCase.$1,
            height: testCase.$2,
          );

          expect(
            radius,
            16.0,
            reason: 'Failed for width: ${testCase.$1}, height: ${testCase.$2}',
          );
        }
      });

      test('returns concave radius capped at 16 for large input sizes', () {
        // Group Larger than 16
        final testCases = [
          // Case: width * 0.04 is smaller than height * 0.1
          // and the smaller one is larger than 16
          (425.0, 180.0),
          // Case: height * 0.1 is smaller than width * 0.04
          // and the smaller one is larger than 16
          (500.0, 170.0),
          // Case: width * 0.04 and height * 0.1 are the same
          // and the smaller one is larger than 16
          (425.0, 170.0),
          // Case: extreme large size
          (5000.0, 5000.0),
        ];

        for (final testCase in testCases) {
          final radius = TicketUtils.calculateConcaveRadius(
            width: testCase.$1,
            height: testCase.$2,
          );

          expect(
            radius,
            16.0,
            reason: 'Failed for width: ${testCase.$1}, height: ${testCase.$2}',
          );
        }
      });

      test('returns concave radius greater than 0 and never exceeds 16', () {
        final edgeCaseSizes = [
          // extreme small size
          (10.0, 5.0),
          // extreme large size
          (5000.0, 5000.0),
        ];

        for (final size in edgeCaseSizes) {
          final radius = TicketUtils.calculateConcaveRadius(
            width: size.$1,
            height: size.$2,
          );
          expect(
            radius,
            greaterThan(0.0),
            reason: 'Failed for width: ${size.$1}, height: ${size.$2}',
          );
          expect(
            radius,
            lessThanOrEqualTo(16.0),
            reason: 'Failed for width: ${size.$1}, height: ${size.$2}',
          );
        }
      });
    });
    group('calculateCornerRadius', () {
      test('returns corner radius for extra small ticket', () {
        final width = TestConstants.extraSmallSize.$1;
        final height = TestConstants.extraSmallSize.$2;
        final cornerRadius = TicketUtils.calculateCornerRadius(
          width: width,
          height: height,
        );
        expect(
          cornerRadius,
          4.0,
          reason: 'Failed for width: $width, height: $height',
        );
      });

      test('returns corner radius for small ticket', () {
        final width = TestConstants.smallSize.$1;
        final height = TestConstants.smallSize.$2;
        final cornerRadius = TicketUtils.calculateCornerRadius(
          width: width,
          height: height,
        );
        expect(
          cornerRadius,
          10.0,
          reason: 'Failed for width: $width, height: $height',
        );
      });

      test('returns corner radius for normal ticket', () {
        final width = TestConstants.normalSize.$1;
        final height = TestConstants.normalSize.$2;
        final cornerRadius = TicketUtils.calculateCornerRadius(
          width: width,
          height: height,
        );
        expect(
          cornerRadius,
          16.0,
          reason: 'Failed for width: $width, height: $height',
        );
      });

      // Removed the separate extreme sizes test
    });
  });
}

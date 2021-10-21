import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goldendemo/main.dart';

import 'helpers.dart';
import 'indigo_golden_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Home', () {
    final device = const Device.zeplinDesignsWithInsets().highest();

    group('golden tests', () {
      Widget _build() {
        return simulateMainTabNavigator(
          const MyHomePage(),
        );
      }

      group('group1', () {
        indigoGoldenWidgetBuilderTest(
          name: 'Test1',
          setup: (tester) async {},
          builder: (_) {
            return _build();
          },
          // No insets
          device: const Device.zeplinDesigns(),
        );

        indigoGoldenWidgetBuilderTest(
          name: 'Test2',
          setup: (tester) async {},
          builder: (_) {
            return _build();
          },
          device: const Device.zeplinDesignsWithInsets().copyWith(width: 1024),
        );

        indigoGoldenWidgetBuilderTest(
          name: 'Test3',
          setup: (tester) async {},
          builder: (_) {
            return _build();
          },
          device: const Device.zeplinDesignsWithInsets().copyWith(width: 1024),
        );

        indigoGoldenWidgetBuilderTest(
          name: 'Test4',
          setup: (tester) async {},
          builder: (_) {
            return _build();
          },
          // No insets
          device: const Device.zeplinDesigns().copyWith(height: 400),
        );
      });

      group('group2', () {
        indigoGoldenWidgetBuilderTest(
          name: 'Test5',
          setup: (tester) async {},
          builder: (_) {
            return _build();
          },
          device: const Device.zeplinDesignsWithInsets().higher(),
        );

        indigoGoldenWidgetBuilderTest(
          name: 'Test6',
          setup: (tester) async {},
          builder: (_) {
            return _build();
          },
          device: const Device.zeplinDesignsWithInsets().higher(),
        );

        indigoGoldenWidgetBuilderTest(
          name: 'Test7',
          setup: (tester) async {},
          builder: (_) {
            return _build();
          },
          device: device,
        );
      });

      group('group3', () {
        indigoGoldenWidgetBuilderTest(
          name: 'Test8',
          setup: (tester) async {},
          builder: (_) {
            return _build();
          },
          device: const Device.zeplinDesignsWithInsets().higher(),
        );

        indigoGoldenWidgetBuilderTest(
          name: 'Test9',
          setup: (tester) async {},
          builder: (_) {
            return _build();
          },
          device: const Device.zeplinDesignsWithInsets().higher(),
        );
      });
    });
  });
}

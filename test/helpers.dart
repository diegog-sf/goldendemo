import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mocktail/mocktail.dart';

class Device {
  static const _defaultInsets = EdgeInsets.only(top: 44, bottom: 34);
  final String? name;
  final double devicePixelRatio;
  final double width;
  final double height;
  final EdgeInsets insets;

  const Device({
    this.name,
    this.devicePixelRatio = 1.0,
    this.width = 320.0,
    this.height = 640.0,
    this.insets = EdgeInsets.zero,
  });

  Device smaller() => copyWith(height: height / 2);

  Device higher() => copyWith(height: height * 2.0);

  Device highest() => copyWith(height: height * 3.0);

  Device withInsets() => copyWith(insets: _defaultInsets);

  const Device.zeplinPhoneDesignsWithInsets()
      : this(
          name: 'phone',
          devicePixelRatio: 2.0,
          width: 375.0,
          height: 812.0,
          insets: _defaultInsets,
        );

  const Device.zeplinDesigns()
      : this(devicePixelRatio: 2.0, width: 375.0, height: 812.0);

  const Device.zeplinDesignsWithInsets()
      : this(
          devicePixelRatio: 2.0,
          width: 375.0,
          height: 812.0,
          insets: _defaultInsets,
        );

  Device copyWith(
          {final double? devicePixelRatio,
          final double? width,
          final double? height,
          final EdgeInsets? insets,
          final String? name}) =>
      Device(
          name: name,
          devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
          width: width ?? this.width,
          height: height ?? this.height,
          insets: insets ?? this.insets);
}

class MockWindowPadding extends Mock implements WindowPadding {}

/// Sets size of test device
void setupSize(Device device) {
  final binding = TestWidgetsFlutterBinding.ensureInitialized()
      as TestWidgetsFlutterBinding;
  binding.window.physicalSizeTestValue = Size(
      device.width * device.devicePixelRatio,
      device.height * device.devicePixelRatio);
  binding.window.devicePixelRatioTestValue = device.devicePixelRatio;
  final padding = MockWindowPadding();
  when(() => padding.bottom)
      .thenReturn(device.insets.bottom * device.devicePixelRatio);
  when(() => padding.top)
      .thenReturn(device.insets.top * device.devicePixelRatio);
  when(() => padding.left)
      .thenReturn(device.insets.left * device.devicePixelRatio);
  when(() => padding.right)
      .thenReturn(device.insets.right * device.devicePixelRatio);
  binding.window.paddingTestValue = padding;
  binding.window.viewPaddingTestValue = padding;
}

/// Take a screenshot of the whole screen
Future<void> takeAScreenshot(dynamic key, {int? version}) async {
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('./goldens/$key', version: version),
  );
}

bool _goldenDebugDisableInfiniteAnimations = false;

bool get goldenDebugDisableInfiniteAnimations =>
    _goldenDebugDisableInfiniteAnimations;
bool indigoDebugDisableInfiniteAnimations = false;

set goldenDebugDisableInfiniteAnimations(bool value) {
  _goldenDebugDisableInfiniteAnimations = value;
  // Pass the setting into ICL as well.
  indigoDebugDisableInfiniteAnimations = value;
}

/// Widget screenshot test
///
/// Test that test a widget provided by [builder] by creating a screenshot. You
/// need provide a [name] for the test, that will be also used as a screenshot
/// name.
/// You can use [device] if you need to test on different screen sizes.
/// To setup your test before creating a widget you can use [setup].
///
/// **Those tests executes only on MacOS**
/// Test execution on different OSes might give different results. So executing
/// the test on Linux will give different result than executing it on MacOS.
/// This is why all those tests are skipped on different OS than Linux.
@isTest
void goldenWidgetBuilderTest({
  required String name,
  required WidgetBuilder builder,
  bool supportMultipleDevices = false,
  Device device = const Device.zeplinPhoneDesignsWithInsets(),
  List<LocalizationsDelegate>? localizationsDelegates,
  supportedLocales,
  localeResolutionCallback,
  Future<void> Function(WidgetTester tester)? setup,
  Future<void> Function(WidgetTester tester)? tearDown,
  Future<void> Function(WidgetTester tester)? action,
  bool useDarkTheme = false,
  bool skip = false,
}) =>
    testWidgets(name, (WidgetTester tester) async {
      debugDisableShadows = false;
      goldenDebugDisableInfiniteAnimations = true;
      setupSize(device);
      try {
        if (setup != null) {
          await setup(tester);
        }

        final widget = MaterialApp(
          home: Builder(builder: builder),
        );

        await tester.pumpWidget(
          widget,
        );

        if (action != null) {
          await tester.pumpAndSettle();
          await action(tester);
        }
        await tester.pumpAndSettle();
        await takeAScreenshot(
          supportMultipleDevices ? '$name.${device.name}.png' : '$name.png',
        );
      } finally {
        debugDisableShadows = true;
        goldenDebugDisableInfiniteAnimations = true;

        if (tearDown != null) {
          await tearDown(tester);
        }
      }
    }, skip: !Platform.isMacOS || skip);

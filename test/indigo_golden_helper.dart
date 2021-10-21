import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'helpers.dart';

//Wraps the golden helpers library, while injecting some of our own
//previously hard-coded values into the library
//namely our localized delegates.
//Also provides references to local asset files
@isTest
void indigoGoldenWidgetBuilderTest({
  required String name,
  required WidgetBuilder builder,
  bool supportMultipleDevices = false,
  Device device = const Device.zeplinPhoneDesignsWithInsets(),
  Future<void> Function(WidgetTester tester)? setup,
  Future<void> Function(WidgetTester tester)? tearDown,
  Future<void> Function(WidgetTester tester)? action,
  bool useDarkTheme = false,
  bool skip = false,
}) =>
    goldenWidgetBuilderTest(
      name: name,
      builder: builder,
      supportMultipleDevices: supportMultipleDevices,
      device: device,
      setup: setup,
      tearDown: tearDown,
      action: action,
      useDarkTheme: useDarkTheme,
      skip: skip,
    );

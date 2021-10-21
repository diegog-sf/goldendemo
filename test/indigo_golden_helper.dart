import 'package:flutter/foundation.dart';
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

// This simulates similar screen look as our main_tab_navigator.dart
Widget simulateMainTabNavigator(Widget child) {
  return Scaffold(
      backgroundColor: Color(0xfff6f6f6),
      body: child,
      bottomNavigationBar: const Material(
        elevation: 4,
        color: Colors.white,
        child: SafeArea(
          left: false,
          right: false,
          top: false,
          bottom: true,
          child: SizedBox(
            width: double.infinity,
            height: 56.0,
          ),
        ),
      ));
}

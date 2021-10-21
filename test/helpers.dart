import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mocktail/mocktail.dart';

/// Child need to be in MaterialApp
///
/// Optional parameter [navigatorObserver] can be used for verifying if
/// navigation between views is implemented correctly.
/// Look at [MockNavigatorObserver] for details how to verify navigation.
Widget makeWidgetThemed(
  Widget child, {
  NavigatorObserver? navigatorObserver,
  RouteFactory? onGenerateRoute,
  bool useDarkTheme = false,
  List<LocalizationsDelegate>? localizationsDelegates,
  supportedLocales,
  localeResolutionCallback,
}) =>
    MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: Color.fromRGBO(100, 181, 246, 1),
          ),
        ),
        color: Colors.white,
        localizationsDelegates: localizationsDelegates,
        supportedLocales:
            supportedLocales ?? <Locale>[const Locale('en', 'US')],
        localeResolutionCallback: localeResolutionCallback ??
            ((Locale? local, Iterable<Locale> locales) => null),
        navigatorObservers: [if (navigatorObserver != null) navigatorObserver],
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: (settings) => PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, _, __) => Text(
                  'Unknown route ${settings.toString()}',
                  style: Theme.of(context).textTheme.bodyText2,
                )),
        home: Scaffold(body: child));

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

  const Device.zeplinTabletDesignsWithInsets()
      : this(
          name: 'tablet',
          devicePixelRatio: 2.0,
          width: 800.0,
          height: 1280.0,
          insets: const EdgeInsets.only(top: 24),
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

  const Device.iPhoneX()
      : this(devicePixelRatio: 3.0, width: 375.0, height: 812.0);

  const Device.iPhoneXWithInsets()
      : this(
          devicePixelRatio: 3.0,
          width: 375.0,
          height: 812.0,
          insets: const EdgeInsets.only(top: 44, bottom: 34),
        );

  const Device.pixelXl()
      : this(devicePixelRatio: 4.0, width: 360, height: 640.0);

  const Device.chromeBookPixel()
      : this(devicePixelRatio: 2.0, width: 1280.0, height: 850.0);

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

class DeviceFrame extends Decoration {
  final EdgeInsets insets;

  const DeviceFrame(this.insets);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return DeviceFrameBoxPainter(insets);
  }
}

/// Box to draw a device frame
class DeviceFrameBoxPainter extends BoxPainter {
  final EdgeInsets insets;
  final Paint background = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = Colors.black.withOpacity(0.14)
    ..strokeWidth = 0;

  final Paint linePaint = Paint()
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..color = Colors.black.withOpacity(0.14)
    ..strokeWidth = 5;

  DeviceFrameBoxPainter(this.insets);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size;
    if (insets.left != 0) {
      canvas.drawRect(
          Rect.fromLTWH(0, insets.top, insets.left, size!.height - insets.top),
          background);
    }
    if (insets.right != 0) {
      canvas.drawRect(
          Rect.fromLTWH(size!.width - insets.right, insets.top, insets.right,
              size.height - insets.top),
          background);
    }
    if (insets.top != 0) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size!.width, insets.top), background);
    }

    if (insets.bottom != 0) {
      final offset = (insets.bottom - 5.0) / 2.0;
      canvas.drawLine(Offset(120, size!.height - offset),
          Offset(size.width - 120, size.height - offset), linePaint);
    }
  }
}

@isTest
void multiDeviceGoldenWidgetBuilderTest({
  required String name,
  required WidgetBuilder builder,
  Future<void> Function(WidgetTester tester)? setup,
  Future<void> Function(WidgetTester tester)? action,
}) {
  goldenWidgetBuilderTest(
      name: name,
      supportMultipleDevices: true,
      builder: builder,
      device: const Device.zeplinPhoneDesignsWithInsets(),
      action: action,
      setup: setup,
      localizationsDelegates: []);
  goldenWidgetBuilderTest(
      name: name,
      supportMultipleDevices: true,
      builder: builder,
      device: const Device.zeplinTabletDesignsWithInsets(),
      action: action,
      setup: setup,
      localizationsDelegates: []);
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

        final widget = makeWidgetThemed(
            Container(
              alignment: Alignment.topLeft,
              color: Colors.white,
              child: Builder(builder: builder),
            ),
            localizationsDelegates: localizationsDelegates ?? [],
            supportedLocales:
                supportedLocales ?? <Locale>[const Locale('en', 'US')],
            localeResolutionCallback: localeResolutionCallback ??
                (Locale? local, Iterable<Locale> locales) {},
            useDarkTheme: useDarkTheme);

        final window = TestWidgetsFlutterBinding.ensureInitialized().window;
        final edgeInsets = EdgeInsets.fromWindowPadding(
            window.padding, window.devicePixelRatio);
        await tester.pumpWidget(DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: DeviceFrame(edgeInsets),
          child: widget,
        ));

        if (action != null) {
          await tester.pumpAndSettle();
          await action(tester);
        }
        await tester.pumpAndSettle();
        await takeAScreenshot(supportMultipleDevices
            ? '${'$name.${device.name}.png'}'
            : '$name.png');
      } finally {
        debugDisableShadows = true;
        goldenDebugDisableInfiniteAnimations = true;

        if (tearDown != null) {
          await tearDown(tester);
        }
      }
    }, skip: !Platform.isMacOS || skip);

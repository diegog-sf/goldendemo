import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => HomeVariantA();
}

/// [BorderRadius] values
abstract class ThemeBorder {
  static const smallButtonRadius = 4.0;
  static const cardRadiusMedium = 6.0;
  static const cardRadiusLarge = 10.0;
  static const buttonRadius = 36.0;
}

abstract class ThemePadding {
  /// Padding of size 0.
  static const none = 0.0;

  /// Padding of size 2.
  static const extraSmall = 2.0;

  /// Padding of size 4.
  static const small = 4.0;

  /// Padding of size 8.
  static const medium = 8.0;

  /// Padding of size 12.
  static const big = 12.0;

  /// Padding of size 16.
  static const large = 16.0;

  /// Padding of size 24.
  static const xl = 24.0;

  /// Padding of size 32.
  static const xxl = 32.0;

  /// Padding of size 96.
  static const xxxl = 96.0;

  /// This is the basic padding that is used for items in a list.
  static const insetPrimary = EdgeInsets.symmetric(
    horizontal: large,
    vertical: medium,
  );

  static const insetAllLarge = EdgeInsets.all(large);
  static const insetAllExtraLarge = EdgeInsets.all(xl);
}

const indigoNavigationButtonHeight = 112.0;

class HomeVariantA extends State<MyHomePage> {
  /// Height of the header
  double get _headerHeight =>
      max(MediaQuery.of(context).size.height * 0.55, 460.0);

  /// Height of the status bar.
  double get _statusBarHeight => MediaQuery.of(context).padding.top;

  /// Height of the floating widget.
  final _floatingHeight = 116.0;

  /// Height of the floating widget which overflow the header.
  double get _floatingOverflow => _floatingHeight * .33;

  /// Height of the floating widget which stay out of the header.
  double get _floatingRemaining => _floatingHeight - _floatingOverflow;

  /// Default position of the floating widget.
  double get _defaultFloatingTopPosition =>
      _statusBarHeight + _headerHeight - _floatingOverflow;

  /// ScrollController offset.
  double _offset = 0;

  /// Distance from the bottom of the AppBar to the bottom of the floating widget.
  double get _limit1 => _headerHeight + _floatingRemaining - kToolbarHeight;

  /// Opacity of the floating widget, the value changes depending on the the [_offset].
  double get _opacity => _offset > _limit1 ? 0 : 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: _defaultFloatingTopPosition - _offset,
            right: 0,
            left: 0,
            child: IgnorePointer(
              ignoring: _opacity == 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _opacity,
                child: SizedBox(
                  height: _floatingHeight,
                  child: const DiscoverNavCarouselVariantA(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SimpleContainer extends StatelessWidget {
  /// Passing in an elevation with overrule boxShadow and always render a [Material] object.
  final double? elevation;
  final BoxShadow? boxShadow;
  final BorderRadius? borderRadius;
  final Widget? child;
  final Color? shadowColor;
  final double? width;
  final double? height;
  final Color? color;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderSide border;
  final Matrix4? transform;

  const SimpleContainer({
    this.borderRadius,
    this.elevation,
    this.boxShadow,
    this.child,
    this.shadowColor,
    this.width,
    this.height,
    this.color,
    this.transform,
    this.padding,
    this.margin,
    this.border = BorderSide.none,
  });

  Widget _wrapContainer(child) {
    return Container(
      width: width,
      padding: padding,
      height: height,
      margin: margin,
      transform: transform,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            borderRadius ?? BorderRadius.circular(ThemeBorder.cardRadiusLarge),
        boxShadow: boxShadow != null ? [boxShadow!] : null,
      ),
      child: child,
    );
  }

  Widget _wrapMaterial(child) {
    return Container(
      width: width,
      padding: padding,
      height: height,
      margin: margin,
      child: Material(
        child: child,
        color: color,
        shadowColor: shadowColor ?? Color(0x4f000000),
        elevation: elevation!,
        shape: RoundedRectangleBorder(
          side: border,
          borderRadius: borderRadius ??
              BorderRadius.circular(ThemeBorder.cardRadiusLarge),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (elevation == null) ? _wrapContainer(child) : _wrapMaterial(child);
  }
}

final indigoButtonGradient = const LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  stops: [0, 1],
  colors: [
    Color(0xFF845afe),
    Color(0xFF4857f3),
  ],
);

class DiscoverNavCarouselVariantA extends StatelessWidget {
  final double _buttonHeight = 112;
  final double _buttonWidth = 112;

  const DiscoverNavCarouselVariantA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        child: Row(
          children: [
            const SizedBox(width: ThemePadding.large),
            // Check In
            _navButton(
              assetPath: 'assets/carousel_check_in.svg',
              label: 'Check in',
              indigoButton: true,
              onPressed: () {},
            ),
            const SizedBox(width: ThemePadding.medium),
            // Dining
            _navButton(
              assetPath: 'assets/carousel_dining.svg',
              label: 'Dining',
              onPressed: () {},
            ),
            const SizedBox(width: ThemePadding.medium),
            // Entertainment
            _navButton(
              assetPath: 'assets/carousel_entertainment.svg',
              label: 'Entertainment',
              onPressed: () {},
            ),

            const SizedBox(width: ThemePadding.medium),
            // Nightlife
            _navButton(
              assetPath: 'assets/carousel_pools.svg',
              label: 'Pools',
              onPressed: () {},
            ),

            const SizedBox(width: ThemePadding.medium),
            // Nightlife
            _navButton(
              assetPath: 'assets/carousel_nightlife.svg',
              label: 'NightLife',
              onPressed: () {},
            ),

            const SizedBox(width: ThemePadding.medium),
            _navButton(
              assetPath: 'assets/carousel_spas.svg',
              label: 'Spas',
              onPressed: () {},
            ),

            const SizedBox(width: ThemePadding.large),
          ],
        ),
      ),
    );
  }

  Widget _navButton({
    Key? key,
    required String assetPath,
    required String label,
    required Function onPressed,
    bool indigoButton = false,
  }) {
    return NavigationButton(
      key: key,
      icon: SvgPicture.asset(
        assetPath,
        fit: BoxFit.fill,
        color: indigoButton ? Colors.white : null,
      ),
      height: _buttonHeight,
      width: _buttonWidth,
      label: label,
      onPressed: onPressed as dynamic Function(),
      indigoButton: indigoButton,
    );
  }
}

class NavigationButton extends StatelessWidget {
  final String label;
  final String? value;
  final Function() onPressed;
  final Widget? icon;
  final double? width;
  final double height;
  final bool indigoButton;
  final BoxBorder? border;
  final double elevation;
  final Color? textColor;

  const NavigationButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.width,
    this.height = indigoNavigationButtonHeight,
    this.indigoButton = false,
    this.border,
    this.elevation = 2,
    this.value,
    this.textColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SimpleContainer(
      height: height,
      elevation: elevation,
      child: Container(
        decoration: indigoButton
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ThemeBorder.cardRadiusLarge,
                ),
                border: border,
                gradient: indigoButtonGradient,
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ThemeBorder.cardRadiusLarge,
                ),
                border: border,
              ),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                ThemePadding.insetAllLarge),
            backgroundColor: MaterialStateProperty.all<Color?>(
              indigoButton ? null : Colors.white,
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ThemeBorder.cardRadiusLarge,
                ),
              ),
            ),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                // if (states.contains(MaterialState.pressed)) {
                //   return indigoButton
                //       ? IndigoColors.lightSplash
                //       : theme.splashColor;
                // }
                // return null;
              },
            ),
          ),
          onPressed: onPressed,
          child: Container(
            alignment: Alignment.centerLeft,
            width: (width ?? double.infinity) +
                ThemePadding.small +
                ThemePadding.extraSmall,
            constraints: BoxConstraints(
              minHeight: height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: ThemePadding.medium),
                    child: icon,
                  ),
                if (value != null)
                  Text(
                    value!,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.button!.copyWith(
                        color: _labelColor(context),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _labelColor(BuildContext context) {
    if (textColor != null) {
      return textColor!;
    } else {
      return indigoButton ? Colors.white : Theme.of(context).primaryColor;
    }
  }
}

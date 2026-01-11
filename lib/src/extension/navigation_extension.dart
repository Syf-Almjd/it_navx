import 'package:flutter/material.dart';

/// Extension methods for easier navigation using BuildContext
///
/// These extensions provide convenient shortcuts for common navigation patterns
extension NavigationExtension on BuildContext {
  /// Navigate to a new page
  ///
  /// Example:
  /// ```dart
  /// context.push(MyPage());
  /// ```
  Future<T?> push<T>(Widget page) {
    return Navigator.push<T>(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Navigate to a new page with a custom route
  ///
  /// Example:
  /// ```dart
  /// context.pushRoute(MyCustomRoute());
  /// ```
  Future<T?> pushRoute<T>(Route<T> route) {
    return Navigator.push<T>(this, route);
  }

  /// Replace the current page with a new one
  ///
  /// Example:
  /// ```dart
  /// context.pushReplacement(HomePage());
  /// ```
  Future<T?> pushReplacement<T, TO>(Widget page) {
    return Navigator.pushReplacement<T, TO>(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Navigate to a new page and remove all previous routes
  ///
  /// Example:
  /// ```dart
  /// context.pushAndRemoveUntil(LoginPage());
  /// ```
  Future<T?> pushAndRemoveUntil<T>(
    Widget page, {
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushAndRemoveUntil<T>(
      this,
      MaterialPageRoute(builder: (_) => page),
      predicate ?? (_) => false,
    );
  }

  /// Pop the current route
  ///
  /// Example:
  /// ```dart
  /// context.pop();
  /// ```
  void pop<T>([T? result]) {
    Navigator.pop<T>(this, result);
  }

  /// Check if the navigator can pop
  ///
  /// Example:
  /// ```dart
  /// if (context.canPop()) {
  ///   context.pop();
  /// }
  /// ```
  bool canPop() {
    return Navigator.canPop(this);
  }

  /// Pop until reaching a specific route
  ///
  /// Example:
  /// ```dart
  /// context.popUntil((route) => route.isFirst);
  /// ```
  void popUntil(bool Function(Route<dynamic>) predicate) {
    Navigator.popUntil(this, predicate);
  }

  /// Navigate to a named route
  ///
  /// Example:
  /// ```dart
  /// context.pushNamed('/home');
  /// ```
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(this, routeName, arguments: arguments);
  }

  /// Replace current route with a named route
  ///
  /// Example:
  /// ```dart
  /// context.pushReplacementNamed('/login');
  /// ```
  Future<T?> pushReplacementNamed<T, TO>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      this,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate to a named route and remove all previous routes
  ///
  /// Example:
  /// ```dart
  /// context.pushNamedAndRemoveUntil('/home');
  /// ```
  Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName, {
    bool Function(Route<dynamic>)? predicate,
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      this,
      routeName,
      predicate ?? (_) => false,
      arguments: arguments,
    );
  }

  /// Show a modal bottom sheet
  ///
  /// Example:
  /// ```dart
  /// context.showBottomSheet(MyBottomSheet());
  /// ```
  Future<T?> showBottomSheet<T>(
    Widget child, {
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      builder: (_) => child,
    );
  }

  /// Show a dialog
  ///
  /// Example:
  /// ```dart
  /// context.showDialog(MyDialog());
  /// ```
  Future<T?> showDialogWidget<T>(
    Widget child, {
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (_) => child,
    );
  }

  /// Show a snackbar with a message
  ///
  /// Example:
  /// ```dart
  /// context.showSnackBar('Hello World!');
  /// ```
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }

  /// Hide the current snackbar
  ///
  /// Example:
  /// ```dart
  /// context.hideSnackBar();
  /// ```
  void hideSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }
}

/// Extension for custom page transitions
extension CustomTransitionExtension on BuildContext {
  /// Navigate with a fade transition
  ///
  /// Example:
  /// ```dart
  /// context.fadeTransition(MyPage());
  /// ```
  Future<T?> fadeTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.push<T>(
      this,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Navigate with a slide transition
  ///
  /// Example:
  /// ```dart
  /// context.slideTransition(MyPage());
  /// ```
  Future<T?> slideTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Offset begin = const Offset(1.0, 0.0),
  }) {
    return Navigator.push<T>(
      this,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: begin,
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  /// Navigate with a scale transition
  ///
  /// Example:
  /// ```dart
  /// context.scaleTransition(MyPage());
  /// ```
  Future<T?> scaleTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.push<T>(
      this,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }

  /// Navigate with a rotation transition
  ///
  /// Example:
  /// ```dart
  /// context.rotationTransition(MyPage());
  /// ```
  Future<T?> rotationTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.push<T>(
      this,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return RotationTransition(
            turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
            child: child,
          );
        },
      ),
    );
  }
}

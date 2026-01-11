import 'package:flutter/material.dart';
import 'package:it_navigates/src/navigate.dart';
import 'package:it_navigates/src/shared/components.dart';
import 'package:it_navigates/src/shared/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_state.dart';

/// A Cubit that manages navigation state throughout the app
///
/// Provides various navigation methods with built-in state management,
/// guest mode protection, and error handling.
///
/// Example:
/// ```dart
/// final navCubit = NavigationCubit.get(context);
/// await navCubit.navigate(context, MyPage());
/// ```
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationInitial());

  /// Gets the NavigationCubit instance from the context
  static NavigationCubit get(BuildContext context) => BlocProvider.of(context);

  /// Navigates to a new page with optional pre-navigation checks
  ///
  /// Automatically handles guest mode by showing a sign-in dialog
  Future<void> navigate(BuildContext context, Widget widget) async {
    try {
      preNavigation();

      if (isGuestMode) {
        if (!context.mounted) return;
        await showChoiceDialog(
          context: context,
          title: "Sign in required!",
          content: "Please sign in to continue",
          onYes: () => navigateToSliderLogout(context),
        );
        return;
      }

      if (!context.mounted) return;
      final pushFuture = Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => widget),
      );
      emit(PagePushed(pageName: widget.runtimeType));
      await pushFuture;
    } catch (e) {
      debugPrint("Navigation Error: $e");
    }
  }

  /// Replaces the current route with a new page
  ///
  /// Uses a zero-duration transition for instant replacement
  ///
  /// Example:
  /// ```dart
  /// await navCubit.navigateReplaced(context, HomePage());
  /// ```
  Future<void> navigateReplaced(BuildContext context, Widget widget) async {
    try {
      final pushFuture = Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => widget,
          transitionDuration: Duration.zero,
        ),
      );
      emit(PagePushed(pageName: widget.runtimeType));
      await pushFuture;
    } catch (e) {
      debugPrint("Navigation Replacement Error: $e");
    }
  }

  /// Navigates to a new page and removes all previous routes
  ///
  /// Useful for logout flows or completing onboarding
  ///
  /// Example:
  /// ```dart
  /// await navCubit.navigateOff(context, LoginPage());
  /// ```
  Future<void> navigateOff(BuildContext context, Widget widget) async {
    try {
      final pushFuture = Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget),
        (_) => false,
      );
      emit(PagePushedOff(pageName: widget.runtimeType));
      await pushFuture;
    } catch (e) {
      debugPrint("Navigation Off Error: $e");
    }
  }

  /// Navigates to the home page defined in authRouter
  ///
  /// Clears the navigation stack and goes to the authenticated home
  ///
  /// Example:
  /// ```dart
  /// await navCubit.navigateToHome(context);
  /// ```
  Future<void> navigateToHome(BuildContext context) async {
    try {
      final pushFuture = Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => authRouter()),
        (_) => false,
      );
      emit(HomeState());
      await pushFuture;
    } catch (e) {
      debugPrint("Navigation to Home Error: $e");
    }
  }

  /// Navigates to the splash/intro screen, typically used for logout
  ///
  /// Uses a post-frame callback to ensure safe navigation timing
  ///
  /// Example:
  /// ```dart
  /// await navCubit.navigateToSliderLogout(context);
  /// ```
  Future<void> navigateToSliderLogout(BuildContext context) async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final pushFuture = Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => splashScreen()),
          (_) => false,
        );
        emit(IntroPageState());
        await pushFuture;
      });
    } catch (e) {
      debugPrint("Navigation to Slider Logout Error: $e");
    }
  }

  /// Pops the current route from the navigation stack
  ///
  /// Only pops if there's a previous route available
  ///
  /// Example:
  /// ```dart
  /// navCubit.pop(context);
  /// ```
  void pop(BuildContext context) {
    final currentRoute = ModalRoute.of(context);

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      emit(PagePopped(pageName: currentRoute?.settings.name ?? "Unknown"));
    } else {
      debugPrint("Cannot pop: No previous route found");
    }
  }
}

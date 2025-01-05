import 'package:flutter/material.dart';
import 'package:it_navigates/src/navigate.dart';
import 'package:it_navigates/src/shared/components.dart';
import 'package:it_navigates/src/shared/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationInitial());

  static NavigationCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> navigate(BuildContext context, Widget widget) async {
    try {
      await preNavigationa();

      if (isGuestMode) {
        await showChoiceDialog(
          context: context,
          title: "Sign in required!",
          content: "Please sign in to continue",
          onYes: () => navigateToSliderLogout(context),
        );
        return;
      }

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => widget),
      );
      emit(PagePushed(pageName: widget.runtimeType));
    } catch (e) {
      debugPrint("Navigation Error: $e");
    }
  }

  Future<void> navigateReplaced(BuildContext context, Widget widget) async {
    try {
      await Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => widget,
          transitionDuration: Duration.zero,
        ),
      );
      emit(PagePushed(pageName: widget.runtimeType));
    } catch (e) {
      debugPrint("Navigation Replacement Error: $e");
    }
  }

  Future<void> navigateOff(BuildContext context, Widget widget) async {
    try {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget),
        (_) => false,
      );
      emit(PagePushedOff(pageName: widget.runtimeType));
    } catch (e) {
      debugPrint("Navigation Off Error: $e");
    }
  }

  Future<void> navigateToHome(BuildContext context) async {
    try {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => authRouter()),
        (_) => false,
      );
      emit(HomeState());
    } catch (e) {
      debugPrint("Navigation to Home Error: $e");
    }
  }

  Future<void> navigateToSliderLogout(BuildContext context) async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => splashScreen()),
          (_) => false,
        );
        emit(IntroPageState());
      });
    } catch (e) {
      debugPrint("Navigation to Slider Logout Error: $e");
    }
  }

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

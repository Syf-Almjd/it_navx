part of 'navigation_cubit.dart';

@immutable
sealed class NavigationState {}

final class NavigationInitial extends NavigationState {}

class PagePushedOff extends NavigationState {
  final Type pageName;

  PagePushedOff({
    required this.pageName,
  });
}

class PagePushed extends NavigationState {
  final Type pageName;

  PagePushed({
    required this.pageName,
  });
}

class PagePopped extends NavigationState {
  final String? pageName;

  PagePopped({
    required this.pageName,
  });
}

class HomeState extends NavigationState {}

class AdminState extends NavigationState {}

class GuestState extends NavigationState {}

class IntroPageState extends NavigationState {}

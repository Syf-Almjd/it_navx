import 'package:it_navigates/src/shared/globals.dart';

class Navigate {
  final Function? preNavigationCallback;
  final Function? postNavigationCallback;

  Navigate({
    this.preNavigationCallback,
    this.postNavigationCallback,
  });

  void init({required bool isGuestMode}) {
    // Execute pre-navigation logic if provided
    preNavigationCallback?.call();

    if (isGuestMode) {
      print("Guest mode is enabled. Navigation restricted.");
    } else {
      print("Navigation allowed.");
    }

    // Execute post-navigation logic if provided
    postNavigationCallback?.call();
  }
}

// Example global functions
preNavigationa() {
  print('Pre Navigation');
}

postNavigation() {
  print('Post Navigation');
}

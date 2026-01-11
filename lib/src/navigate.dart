import 'package:flutter/foundation.dart';

/// A flexible navigation handler that supports pre and post navigation callbacks
class Navigate {
  /// Callback executed before navigation occurs
  final Function? preNavigationCallback;

  /// Callback executed after navigation occurs
  final Function? postNavigationCallback;

  /// Creates a Navigate instance with optional callbacks
  Navigate({
    this.preNavigationCallback,
    this.postNavigationCallback,
  });

  /// Initializes navigation with guest mode check
  ///
  /// [isGuestMode] - If true, restricts navigation for guest users
  void init({required bool isGuestMode}) {
    // Execute pre-navigation logic if provided
    preNavigationCallback?.call();

    if (isGuestMode) {
      debugPrint("Guest mode is enabled. Navigation restricted.");
    } else {
      debugPrint("Navigation allowed.");
    }

    // Execute post-navigation logic if provided
    postNavigationCallback?.call();
  }
}

/// Default pre-navigation callback
///
/// This function is called before navigation to perform any
/// necessary setup or validation
void preNavigation() {
  debugPrint('Pre Navigation');
}

/// Default post-navigation callback
///
/// This function is called after navigation completes
void postNavigation() {
  debugPrint('Post Navigation');
}

/// A powerful Flutter navigation package with state management, guards, and utilities
///
/// This library provides:
/// - State-aware navigation with BLoC pattern
/// - Guest mode protection
/// - Pre/post navigation callbacks
/// - Multiple navigation strategies (push, replace, pushOff)
/// - Customizable dialogs and components
library it_navigates;

// Core navigation
export 'src/cubit/navigation_cubit.dart';
export 'src/navigate.dart' show Navigate, preNavigation, postNavigation;

// Utilities
export 'src/extension/navigation_extension.dart';
export 'src/shared/components.dart'
    show
        showChoiceDialog,
        showLoadingDialog,
        showSuccessDialog,
        showErrorDialog;
export 'src/shared/globals.dart'
    show isGuestMode, appColor, splashScreen, authRouter, initNavigation;

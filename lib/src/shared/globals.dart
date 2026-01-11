import 'package:flutter/material.dart';

/// Global flag to track guest mode status
///
/// When true, certain navigation actions will be restricted
/// and users will be prompted to sign in
bool isGuestMode = false;

/// Global app primary color
///
/// Used throughout navigation components for consistent theming
Color appColor = Colors.blue;

/// Default splash screen widget
///
/// Override this with your own splash screen implementation
///
/// Example:
/// ```dart
/// void main() {
///   splashScreen = () => MySplashScreen();
///   runApp(MyApp());
/// }
/// ```
Widget Function() splashScreen = _defaultSplashScreen;

Widget _defaultSplashScreen() {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flutter_dash,
            size: 100,
            color: appColor,
          ),
          const SizedBox(height: 20),
          const Text(
            "Splash Screen",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Configure your splash screen",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

/// Authentication router widget
///
/// This should return the appropriate screen based on authentication status
///
/// Example:
/// ```dart
/// void main() {
///   authRouter = () => isLoggedIn ? HomePage() : LoginPage();
///   runApp(MyApp());
/// }
/// ```
Widget Function() authRouter = _defaultAuthRouter;

Widget _defaultAuthRouter() {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.login,
            size: 100,
            color: appColor,
          ),
          const SizedBox(height: 20),
          const Text(
            "Auth Router",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Configure your authentication router",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

/// Initializes the navigation package with custom configuration
///
/// Call this in your main() function before runApp()
///
/// Example:
/// ```dart
/// void main() {
///   initNavigation(
///     primaryColor: Colors.purple,
///     guestMode: true,
///     splash: () => MySplashScreen(),
///     auth: () => isLoggedIn ? Home() : Login(),
///   );
///   runApp(MyApp());
/// }
/// ```
void initNavigation({
  Color? primaryColor,
  bool guestMode = false,
  Widget Function()? splash,
  Widget Function()? auth,
}) {
  if (primaryColor != null) appColor = primaryColor;
  isGuestMode = guestMode;
  if (splash != null) splashScreen = splash;
  if (auth != null) authRouter = auth;
}

# it_navigates 🧭

[![pub package](https://img.shields.io/pub/v/it_navigates.svg)](https://pub.dev/packages/it_navigates)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A powerful, elegant Flutter navigation package with state management, guards, animations, and comprehensive routing utilities. Makes navigation across mobile and web apps effortless! 💙

## ✨ Features

- 🎯 **State-aware Navigation** - Built-in BLoC pattern for navigation state management
- 🔐 **Guest Mode Protection** - Automatic handling of unauthenticated user navigation attempts
- 🎨 **Custom Transitions** - Beautiful fade, slide, scale, and rotation animations
- 🚀 **Extension Methods** - Convenient shortcuts for common navigation patterns
- 📱 **Context Extensions** - Easy-to-use extensions on `BuildContext`
- 🎭 **Pre-built Dialogs** - Ready-to-use success, error, loading, and choice dialogs
- 🛡️ **Type-safe** - Fully typed navigation methods
- 📚 **Well Documented** - Comprehensive documentation and examples
- 🧪 **Tested** - Production-ready and thoroughly tested

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  it_navigates: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### Basic Setup

1. **Initialize the package** in your `main()` function:

```dart
import 'package:it_navigates/it_navigates.dart';

void main() {
  // Optional: Configure the package
  initNavigation(
    primaryColor: Colors.purple,
    guestMode: false,
    splash: () => MySplashScreen(),
    auth: () => isLoggedIn ? HomePage() : LoginPage(),
  );
  
  runApp(MyApp());
}
```

2. **Wrap your app** with `BlocProvider`:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
```

### Simple Navigation

Use the convenient context extensions:

```dart
// Push a new page
context.push(ProfilePage());

// Push with replacement
context.pushReplacement(LoginPage());

// Push and remove all previous routes
context.pushAndRemoveUntil(HomePage());

// Pop current page
context.pop();

// Pop with result
context.pop("some result");
```

### Navigation with Custom Transitions

```dart
// Fade transition
context.fadeTransition(DetailsPage());

// Slide transition
context.slideTransition(SettingsPage());

// Scale transition
context.scaleTransition(AboutPage());

// Rotation transition
context.rotationTransition(InfoPage());
```

### Named Routes

```dart
// Navigate to named route
context.pushNamed('/profile', arguments: userId);

// Replace with named route
context.pushReplacementNamed('/home');

// Push named and remove all
context.pushNamedAndRemoveUntil('/login');
```

### Show Dialogs

```dart
// Choice dialog
await showChoiceDialog(
  context: context,
  title: 'Delete Item',
  content: 'Are you sure you want to delete this item?',
  onYes: () {
    // Handle yes
  },
  onNo: () {
    // Handle no
  },
);

// Loading dialog
showLoadingDialog(context, message: 'Processing...');

// Success dialog
await showSuccessDialog(
  context,
  title: 'Success!',
  message: 'Your changes have been saved.',
);

// Error dialog
await showErrorDialog(
  context,
  title: 'Error',
  message: 'Something went wrong.',
);
```

### Show SnackBars and Bottom Sheets

```dart
// Show snackbar
context.showSnackBar('Item added to cart!');

// Show bottom sheet
context.showBottomSheet(
  MyBottomSheetWidget(),
  backgroundColor: Colors.white,
);

// Show dialog widget
context.showDialogWidget(MyCustomDialog());
```

## 🎯 Advanced Usage

### Using NavigationCubit

For more complex navigation with state management:

```dart
final navCubit = NavigationCubit.get(context);

// Navigate with guest mode check
await navCubit.navigate(context, ProfilePage());

// Replace current page
await navCubit.navigateReplaced(context, HomePage());

// Navigate and clear stack
await navCubit.navigateOff(context, LoginPage());

// Navigate to home
await navCubit.navigateToHome(context);

// Pop current route
navCubit.pop(context);
```

### Guest Mode Protection

Enable guest mode to protect certain routes:

```dart
// Enable guest mode
isGuestMode = true;

// When user tries to navigate, they'll see a sign-in prompt
await navCubit.navigate(context, ProtectedPage());
// Shows: "Sign in required! Please sign in to continue"
```

### Navigation State Management

Listen to navigation state changes:

```dart
BlocBuilder<NavigationCubit, NavigationState>(
  builder: (context, state) {
    if (state is PagePushed) {
      print('Navigated to: ${state.pageName}');
    } else if (state is PagePopped) {
      print('Popped from: ${state.pageName}');
    }
    return Container();
  },
)
```

### Custom Callbacks

```dart
final navigate = Navigate(
  preNavigationCallback: () {
    print('About to navigate...');
    // Perform analytics, logging, etc.
  },
  postNavigationCallback: () {
    print('Navigation completed!');
    // Clean up, update state, etc.
  },
);

navigate.init(isGuestMode: false);
```

## 📱 Platform Support

| Platform | Supported |
|----------|-----------|
| iOS      | ✅        |
| Android  | ✅        |
| Web      | ✅        |
| macOS    | ✅        |
| Windows  | ✅        |
| Linux    | ✅        |

## 📖 API Reference

### Extension Methods

#### NavigationExtension
- `push<T>(Widget page)` - Navigate to a new page
- `pushRoute<T>(Route<T> route)` - Navigate with a custom route
- `pushReplacement<T, TO>(Widget page)` - Replace current page
- `pushAndRemoveUntil<T>(Widget page)` - Push and clear stack
- `pop<T>([T? result])` - Pop current page
- `canPop()` - Check if can pop
- `popUntil(predicate)` - Pop until condition
- `pushNamed<T>(String routeName)` - Navigate to named route
- `pushReplacementNamed<T, TO>(String routeName)` - Replace with named route
- `pushNamedAndRemoveUntil<T>(String routeName)` - Push named and clear stack
- `showBottomSheet<T>(Widget child)` - Show modal bottom sheet
- `showDialogWidget<T>(Widget child)` - Show dialog
- `showSnackBar(String message)` - Show snackbar
- `hideSnackBar()` - Hide snackbar

#### CustomTransitionExtension
- `fadeTransition<T>(Widget page)` - Fade transition
- `slideTransition<T>(Widget page)` - Slide transition
- `scaleTransition<T>(Widget page)` - Scale transition
- `rotationTransition<T>(Widget page)` - Rotation transition

### Components

- `showChoiceDialog()` - Customizable choice dialog
- `showLoadingDialog()` - Loading indicator dialog
- `showSuccessDialog()` - Success message dialog
- `showErrorDialog()` - Error message dialog

### NavigationCubit Methods

- `navigate(context, widget)` - Navigate with guest mode check
- `navigateReplaced(context, widget)` - Replace current route
- `navigateOff(context, widget)` - Navigate and clear stack
- `navigateToHome(context)` - Navigate to home
- `navigateToSliderLogout(context)` - Navigate to splash/logout
- `pop(context)` - Pop current route

### Global Configuration

- `initNavigation()` - Initialize package with custom settings
- `isGuestMode` - Toggle guest mode
- `appColor` - Set primary color
- `splashScreen` - Configure splash screen
- `authRouter` - Configure auth routing

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Saif Almajd** ([@syf-almjd](https://github.com/syf-almjd))

## 🌟 Show Your Support

Give a ⭐️ if this project helped you!

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes.

## 🐛 Issues

Please file issues [here](https://github.com/syf-almjd/it_navx/issues).

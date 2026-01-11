# it_navigates Example

This example demonstrates all the features of the `it_navigates` package.

## Features Demonstrated

### 1. Basic Navigation
- Standard push navigation
- Push replacement
- Push and remove until (clearing stack)

### 2. Custom Transitions
- Fade transition
- Slide transition
- Scale transition
- Rotation transition

### 3. Dialogs
- Choice dialog (Yes/No)
- Success dialog
- Error dialog
- Loading dialog

### 4. UI Components  
- Bottom sheets
- Snackbars

### 5. NavigationCubit
- Navigation with state management
- Guest mode toggle

## Running the Example

```bash
# Make sure you're in the example directory
cd example

# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Code Highlights

### Initialization

```dart
void main() {
  initNavigation(
    primaryColor: Colors.deepPurple,
    guestMode: false,
  );
  runApp(const MyApp());
}
```

### BLoC Provider Setup

```dart
return BlocProvider(
  create: (context) => NavigationCubit(),
  child: MaterialApp(
    home: const HomePage(),
  ),
);
```

### Using Extensions

```dart
// Simple navigation
context.push(DetailPage());

// Custom transitions
context.fadeTransition(DetailPage());

// Dialogs
showChoiceDialog(
  context: context,
  title: 'Confirm',
  onYes: () {},
);

// Snackbars
context.showSnackBar('Message!');
```

## Learn More

Check out the [main README](../README.md) for complete documentation.

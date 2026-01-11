import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it_navigates/src/cubit/navigation_cubit.dart';
import 'package:it_navigates/src/shared/globals.dart';

/// Displays a customizable choice dialog with Yes/No options
///
/// This dialog is theme-aware and provides extensive customization options
///
/// Example:
/// ```dart
/// await showChoiceDialog(
///   context: context,
///   title: 'Delete Item',
///   content: 'Are you sure you want to delete this item?',
///   onYes: () => deleteItem(),
///   onNo: () => print('Cancelled'),
/// );
/// ```
Future<T?> showChoiceDialog<T>({
  required BuildContext context,
  String? title,
  String? content,
  bool showCancel = true,
  String yesText = "Ok",
  String noText = "Cancel",
  required Function onYes,
  Function? onNo,
  bool barrierDismissible = true,
  bool useThemeColors = true,
}) {
  final theme = Theme.of(context);
  final backgroundColor = theme.colorScheme.surface;
  final titleColor = useThemeColors ? appColor : theme.colorScheme.primary;

  return showCupertinoDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
        title: title != null ? Text(title) : null,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: titleColor,
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        content: content != null ? Text(content) : null,
        contentTextStyle: TextStyle(
          fontSize: 14,
          color: theme.textTheme.bodyMedium?.color,
        ),
        actions: [
          if (showCancel)
            TextButton(
              child: Text(
                noText,
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
              onPressed: () {
                NavigationCubit.get(context).pop(context);
                onNo?.call();
              },
            ),
          TextButton(
            child: Text(
              yesText,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              NavigationCubit.get(context).pop(context);
              onYes();
            },
          ),
        ],
      );
    },
  );
}

/// Shows a loading dialog with optional message
///
/// Example:
/// ```dart
/// showLoadingDialog(context, message: 'Please wait...');
/// ```
void showLoadingDialog(
  BuildContext context, {
  String message = 'Loading...',
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(child: Text(message)),
          ],
        ),
      );
    },
  );
}

/// Shows a success message dialog
///
/// Example:
/// ```dart
/// await showSuccessDialog(
///   context,
///   title: 'Success',
///   message: 'Operation completed successfully',
/// );
/// ```
Future<void> showSuccessDialog(
  BuildContext context, {
  String title = 'Success',
  required String message,
  String buttonText = 'OK',
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade600),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}

/// Shows an error message dialog
///
/// Example:
/// ```dart
/// await showErrorDialog(
///   context,
///   title: 'Error',
///   message: 'Something went wrong',
/// );
/// ```
Future<void> showErrorDialog(
  BuildContext context, {
  String title = 'Error',
  required String message,
  String buttonText = 'OK',
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red.shade600),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}

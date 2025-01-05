import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it_navigates/src/cubit/navigation_cubit.dart';
import 'package:it_navigates/src/shared/globals.dart';

Future showChoiceDialog(
    {required BuildContext context,
    String? title,
    String? content,
    bool showCancel = true,
    String yesText = "Ok",
    String noText = "Cancel",
    required Function onYes,
    Function? onNo}) {
  return (showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          title: Text(title ?? ""),
          titleTextStyle: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: appColor),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          content: Text(content ?? "Are you Sure?"),
          actions: [
            showCancel
                ? TextButton(
                    child: Text(noText),
                    onPressed: () {
                      NavigationCubit.get(context).pop(context);
                      if (onNo != null) {
                        onNo();
                      }
                    },
                  )
                : Container(),
            TextButton(
              child: Text(yesText),
              onPressed: () {
                NavigationCubit.get(context).pop(context);
                onYes();
              },
            ),
          ],
        );
      }));
}

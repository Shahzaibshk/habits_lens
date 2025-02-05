import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

extension AlertExtensions on BuildContext {
  void showCustomSnackbar(SnackBar snackbar) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  void hideSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }

  void showSuccessSnackBar(
    String text, {
    int? milliseconds,
    SnackBarAction? action,
  }) {
    showPrimarySnackbar(
      text,
      backgroundColor: Colors.green.shade600,
      milliseconds: milliseconds,
      action: action,
    );
  }

  void showErrorSnackBar(
    String text, {
    int? milliseconds,
    SnackBarAction? action,
  }) {
    showPrimarySnackbar(
      text,
      backgroundColor: Colors.red.shade600,
      milliseconds: milliseconds,
      action: action,
    );
  }

  void showPrimarySnackbar(
    final String text, {
    Color? textColor,
    Color? backgroundColor,
    int? milliseconds,
    SnackBarAction? action,
    Color? borderColor,
    double borderWidth = 1.0,
    double borderRadius = 10,
  }) {
    final snackbar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      duration: Duration(milliseconds: milliseconds ?? 2000),
      backgroundColor: backgroundColor ?? const Color(0XFF28282B),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: borderColor ?? Colors.white12,
          width: borderWidth,
        ),
      ),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: action == null,
      closeIconColor: textColor ?? Colors.white,
      action: action,
    );

    showCustomSnackbar(snackbar);
  }

  Future<void> showMessageDialog<T>(
    String title, {
    String? message,
    Widget? content,
    String buttonText = 'OK',
    T? popResult,
  }) {
    return showDialog(
      context: this,
      builder: (context) {
        final titleWidget = Text(title);
        final contentWidget = () {
          // Show Content as first priority
          if (content != null) return content;

          if (message != null) return Text(message);
          return null;
        }.call();

        onTap() => Navigator.of(context).pop(popResult);

        if (Platform.isAndroid) {
          return AlertDialog(
            title: titleWidget,
            content: contentWidget,
            actions: <Widget>[
              TextButton(
                onPressed: onTap,
                child: Text(buttonText),
              ),
            ],
          );
        }

        return CupertinoAlertDialog(
          title: titleWidget,
          content: contentWidget,
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: onTap,
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  Future<T?> showConfirmationDialog<T>(
    String title, {
    String? message,
    Widget? content,
    String actionText = 'Yes',
    String actionTextNegative = 'No',
    FutureOr<T?> Function()? onActionPressed,
    FutureOr<T?> Function()? onActionPressedNegative,
  }) {
    // Either of the actions is a Future and we need to wait for the result
    final waitForActionResult =
        onActionPressed.runtimeType.toString().contains('Future');

    final waitForNegativeActionResult =
        onActionPressedNegative.runtimeType.toString().contains('Future');

    bool isActionLoading = false;
    bool isActionNegativeLoading = false;

    return showDialog<T?>(
      context: this,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          final titleWidget = Text(title);
          final contentWidget = () {
            // Show Content as first priority
            if (content != null) return content;

            if (message != null) return Text(message);
            return null;
          }.call();

          Future<void> onActionTap() async {
            if (waitForActionResult) {
              try {
                isActionLoading = true;
                setState(() {});
                final result = await onActionPressed?.call() ?? true;
                isActionLoading = false;
                setState(() {});
                return Navigator.of(context).pop(result);
              } catch (e) {
                isActionLoading = false;
                setState(() {});
                Navigator.of(context).pop();
              }
            } else {
              onActionPressed?.call();
            }
          }

          Future<void> onActionTapNegative() async {
            if (waitForNegativeActionResult) {
              try {
                isActionNegativeLoading = true;
                setState(() {});
                final result = await onActionPressedNegative?.call() ?? true;
                isActionNegativeLoading = false;
                setState(() {});
                return Navigator.of(context).pop(result);
              } catch (e) {
                isActionNegativeLoading = false;
                setState(() {});
                Navigator.of(context).pop();
              }
            } else {
              onActionPressedNegative?.call();
            }
          }

          final actionButtonChild = isActionLoading
              ? const CupertinoActivityIndicator()
              : Text(actionText);

          final actionButtonNegativeChild = isActionNegativeLoading
              ? const CupertinoActivityIndicator()
              : Text(actionTextNegative);

          if (Platform.isAndroid) {
            return AlertDialog(
              title: titleWidget,
              content: contentWidget,
              actions: <Widget>[
                TextButton(
                  onPressed: onActionTapNegative,
                  child: actionButtonNegativeChild,
                ),
                TextButton(
                  onPressed: onActionTap,
                  child: actionButtonChild,
                ),
              ],
            );
          }

          return CupertinoAlertDialog(
            title: titleWidget,
            content: contentWidget,
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: onActionTapNegative,
                child: actionButtonNegativeChild,
              ),
              CupertinoDialogAction(
                onPressed: onActionTap,
                child: actionButtonChild,
              ),
            ],
          );
        });
      },
    );
  }

  Future<T?> showPrimarySheet<T>({
    required String title,
    required Widget child,
  }) {
    return PrimarySheet.show<T>(
      this,
      title: title,
      child: child,
    );
  }
}

class PrimarySheet extends StatelessWidget {
  final String title;
  final Widget child;
  const PrimarySheet({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kBorderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 56,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadius),
              color: context.adaptive26,
            ),
          ).centered(),
          12.heightBox,
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          12.heightBox,
          Divider(
            height: 0,
            color: context.adaptive12,
          ),
          child,
        ],
      ).safeArea(),
    );
  }

  static Future<T?> show<T>(
    context, {
    required String title,
    required Widget child,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(100),
        ),
      ),
      builder: (context) => PrimarySheet(title: title, child: child),
    );
  }
}

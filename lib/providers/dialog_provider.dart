import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../my_app.dart';
import '../utils/talker_with_extensions.dart';
import '../utils/utils.dart';

final dialogProvider =
    Provider.autoDispose.family<DialogProvider, Object?>((ref, Object? error) {
  return DialogProvider(ref, error);
});

class DialogProvider {
  final Object? e;
  final Ref ref;

  DialogProvider(this.ref, this.e);

  Future<void> showMessageDialog({
    required String title,
    String? message,
    Widget? content,
  }) {
    final context = navigatorKey.currentContext;
    if (context == null) return Future.value();

    return context.showMessageDialog(title, message: message, content: content);
  }

  void showExceptionDialog() {
    if (isSocketException) {
      showNoInternetDialog();
      return;
    }

    e.runtimeType.toString().logError();
    showMessageDialog(
      title: 'Error',
      message: e.toString(),
    );
  }

  bool get isSocketException =>
      e is SocketException || e.toString().contains('SocketException');

  Future showNoInternetDialog() {
    return showMessageDialog(
      title: 'Network Error',
      message: "Seems like, you're not connected to internet",
    );
  }

  void showSuccessSnackBar() {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    context.showSuccessSnackBar(e.toString());
  }

  void showErrorSnackBar() {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    context.showErrorSnackBar(e.toString());
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
    final context = navigatorKey.currentContext;
    if (context == null) return;

    context.showPrimarySnackbar(
      text,
      textColor: textColor,
      backgroundColor: backgroundColor,
      milliseconds: milliseconds,
      action: action,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

import '../utils/utils.dart';

class PrimaryLoadingIndicator extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String message;
  const PrimaryLoadingIndicator({
    super.key,
    required this.isLoading,
    required this.child,
    this.message = 'Loading, Please wait ...',
  });

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: isLoading,
      progressIndicator: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 0.8.sw(context),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: context.theme.canvasColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Image.asset(
                Images.logo,
                width: 32,
                height: 32,
              ),
              16.widthBox,
              Text(message,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500))
                  .expand(),
            ],
          ),
        ),
      ),
      child: child,
    );
  }
}

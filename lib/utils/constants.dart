import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const kBorderRadius = 8.0;

Future<void> kLaunchUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    try {
      final result = await launchUrl(uri);
      debugPrint(result.toString());
      if (!result) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  } else {
    await launchUrl(uri);
  }
}

Widget kImagePlaceHolder(_, __) {
  return const Padding(
    padding: EdgeInsets.all(50.0),
    child: Center(child: CupertinoActivityIndicator()),
  );
}

Widget kErrorWidget(_, __, ___) => const Padding(
      padding: EdgeInsets.all(50),
      child: Center(child: Icon(Icons.error_outline, color: Colors.red)),
    );

Widget kImagePlaceHolderSmall(_, __) {
  return const Center(child: CupertinoActivityIndicator());
}

Widget kErrorWidgetSmall(_, __, ___) =>
    const Center(child: Icon(Icons.error_outline, color: Colors.red));

import 'package:flutter/material.dart';

class KEmpty extends StatelessWidget {
  const KEmpty({
    super.key,
    required this.emptyText,
  });
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.do_not_disturb_on_rounded, color: Theme.of(context).primaryColor, size: 75),
        Padding(
          padding: const EdgeInsets.all(32),
          child: SelectableText(
            emptyText,
            minLines: 1,
            maxLines: 4,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        )
      ],
    );
  }
}

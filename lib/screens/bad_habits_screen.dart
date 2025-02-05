import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:vos/models/habit_model.dart';
import 'package:vos/utils/enum.dart';

import '../utils/app_textstyle.dart';
import '../widgets/primary_rich_text.dart';

class BadHabits extends HookWidget {
  const BadHabits({super.key});

  @override
  Widget build(BuildContext context) {
    final hiveBox = Hive.box<HabitModel>(HiveBox.badHabit.name);

    return hiveBox.isEmpty
        ? Center(child: Text('No item found'))
        : ValueListenableBuilder(
            valueListenable: hiveBox.listenable(),
            builder: (context, value, child) {
              return ListView.builder(
                itemCount: hiveBox.keys.length,
                itemBuilder: (context, index) {
                  final habit = hiveBox.getAt(index);
                  return ListTile(
                    leading: Checkbox(
                      value: false,
                      onChanged: (value) {
                        hiveBox.putAt(index, habit!);
                      },
                    ),
                    title: Text(habit?.name ?? ''),
                    trailing: PrimaryRichText(
                      text: ' Points',
                      linkedText: habit?.points.toString() ?? '',
                      linktextstyle: AppTextstyle.redStyle,
                    ),
                  );
                },
              );
            },
          );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vos/models/habit_model.dart';
import 'package:vos/models/habit_record_model.dart';
import 'package:vos/utils/enum.dart';
import 'package:vos/widgets/primary_error_widet.dart';

import '../utils/app_textstyle.dart';
import '../widgets/primary_rich_text.dart';

class BadHabits extends HookWidget {
  const BadHabits({super.key});

  @override
  Widget build(BuildContext context) {
    final hiveBox = Hive.box<HabitModel>(HiveBox.badHabit.name);

    return ValueListenableBuilder(
      valueListenable: hiveBox.listenable(),
      builder: (context, value, child) {
        if (value.isEmpty) {
          return PrimaryErrorWidget(error: 'No bad habits found');
        }
        return ListView.builder(
          itemCount: hiveBox.keys.length,
          itemBuilder: (context, index) {
            final habit = hiveBox.getAt(index);
            if (habit == null) {
              return const SizedBox.shrink();
            }
            return BadHabbitTile(habit: habit);
          },
        );
      },
    );
  }
}

class BadHabbitTile extends StatefulWidget {
  const BadHabbitTile({
    super.key,
    required this.habit,
  });

  final HabitModel habit;

  @override
  State<BadHabbitTile> createState() => _BadHabbitTileState();
}

class _BadHabbitTileState extends State<BadHabbitTile> {
  @override
  Widget build(BuildContext context) {
    String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final habitRecordBox = Hive.box<HabitRecordModel>(HiveBox.habitRecord.name);

    final isTicked = habitRecordBox
        .get(todayKey)!
        .badHabits
        .map(
          (e) => e.name,
        )
        .toList()
        .contains(widget.habit.name);
    return ListTile(
      onTap: () {
        // habitRecordBox.deleteFromDisk();
        // Hive.box<HabitModel>(HiveBox.badHabit.name).deleteFromDisk();
        // Hive.box<HabitModel>(HiveBox.goodHabit.name).deleteFromDisk();
      },
      leading: Checkbox(
        value: isTicked,
        onChanged: (value) async {
          final habitRecord = habitRecordBox.get(todayKey);
          if (habitRecord == null) return;

          if (value!) {
            habitRecord.badHabits.add(widget.habit);
          } else {
            habitRecord.badHabits.remove(widget.habit);
          }

          await habitRecordBox.put(todayKey, habitRecord);
          setState(() {});
        },
      ),
      title: Text(widget.habit.name ?? ''),
      trailing: PrimaryRichText(
        text: ' Points',
        linkedText: widget.habit.points.toString() ?? '',
        linktextstyle: AppTextstyle.redStyle,
      ),
    );
  }
}

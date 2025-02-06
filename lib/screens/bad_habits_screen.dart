import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hoppy/widgets/KEmpty.dart';
import 'package:intl/intl.dart';

import '../models/habit_model.dart';
import '../models/habit_record_model.dart';
import '../utils/app_textstyle.dart';
import '../utils/enum.dart';
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
          return KEmpty(emptyText: 'There is no bad habbits found. please add some.');
        }
        return ListView.builder(
          itemCount: hiveBox.keys.length,
          itemBuilder: (context, index) {
            final habit = hiveBox.getAt(index);
            final key = hiveBox.keyAt(index);

            if (habit == null) {
              return const SizedBox.shrink();
            }
            return BadHabbitTile(
              habit: habit,
              id: key,
            );
          },
        );
      },
    );
  }
}

class BadHabbitTile extends StatefulWidget {
  const BadHabbitTile({super.key, required this.habit, required this.id});

  final HabitModel habit;
  final dynamic id;

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
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete Habit'),
            content: Text('Are you sure you want to delete this habit?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final badHabbitBox = Hive.box<HabitModel>(HiveBox.badHabit.name);
                  await badHabbitBox.delete(widget.id);
                  final habitRecord = habitRecordBox.get(todayKey);
                  if (habitRecord == null) return;
                  habitRecord.badHabits.remove(widget.habit);
                  await habitRecordBox.put(todayKey, habitRecord);
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Text('Delete'),
              ),
            ],
          ),
        );
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
      title: Text(widget.habit.name),
      trailing: PrimaryRichText(
        text: ' Points',
        linkedText: widget.habit.points.toString(),
        linktextstyle: AppTextstyle.redStyle,
      ),
    );
  }
}

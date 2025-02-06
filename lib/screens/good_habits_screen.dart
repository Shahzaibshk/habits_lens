import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hoppy/widgets/KEmpty.dart';
import 'package:intl/intl.dart';

import '../models/habit_model.dart';
import '../models/habit_record_model.dart';
import '../utils/enum.dart';
import '../widgets/primary_rich_text.dart';

class GoodHabits extends HookWidget {
  const GoodHabits({super.key});

  @override
  Widget build(BuildContext context) {
    final goodHabitBox = Hive.box<HabitModel>(HiveBox.goodHabit.name);

    return ValueListenableBuilder(
      valueListenable: goodHabitBox.listenable(),
      builder: (context, value, child) {
        if (value.isEmpty) {
          return KEmpty(emptyText: 'There is no good habbits found. please add some.');
        }
        log('Good habits found: ${goodHabitBox.values}');
        return ListView.builder(
          itemCount: goodHabitBox.keys.length,
          itemBuilder: (context, index) {
            final habit = goodHabitBox.getAt(index);
            final key = goodHabitBox.keyAt(index);
            if (habit == null) return const SizedBox.shrink();
            return HabitTile(
              habit: habit,
              id: key,
              ontap: () {},
            );
          },
        );
      },
    );
  }
}

class HabitTile extends StatefulWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.id,
    required this.ontap,
  });

  final HabitModel habit;
  final dynamic id;
  final VoidCallback ontap;

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  @override
  Widget build(BuildContext context) {
    String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final habitRecordBox = Hive.box<HabitRecordModel>(HiveBox.habitRecord.name);

    final isTicked = habitRecordBox
        .get(todayKey)!
        .goodHabits
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
                  final goodHabitBox = Hive.box<HabitModel>(HiveBox.goodHabit.name);
                  await goodHabitBox.delete(widget.id);
                  final habitRecord = habitRecordBox.get(todayKey);
                  if (habitRecord == null) return;
                  habitRecord.goodHabits.remove(widget.habit);
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
            habitRecord.goodHabits.add(widget.habit);
          } else {
            habitRecord.goodHabits.remove(widget.habit);
          }

          await habitRecordBox.put(todayKey, habitRecord);
          setState(() {});
        },
      ),
      title: Text(widget.habit.name),
      trailing: PrimaryRichText(
        text: ' Points',
        linkedText: widget.habit.points.toString(),
      ),
    );
  }
}

class PrimaryCheckBox extends StatelessWidget {
  final ValueNotifier<bool> isCheckedNotifier;
  final HabitModel habit;
  final Function(bool) onChange;

  const PrimaryCheckBox({
    super.key,
    required this.isCheckedNotifier,
    required this.habit,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isCheckedNotifier,
      builder: (context, isChecked, child) {
        return Checkbox(
          value: isChecked,
          onChanged: (checked) {
            isCheckedNotifier.value = checked ?? false;
            onChange(isCheckedNotifier.value);
          },
        );
      },
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/habit_model.dart';
import '../models/habit_record_model.dart';
import '../utils/enum.dart';
import '../widgets/primary_error_widet.dart';
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
          return PrimaryErrorWidget(
            error: 'No good habits found',
          );
        }
        log('Good habits found: ${goodHabitBox.values}');
        return ListView.builder(
          itemCount: goodHabitBox.keys.length,
          itemBuilder: (context, index) {
            final habit = goodHabitBox.getAt(index);
            if (habit == null) return const SizedBox.shrink();
            return HabitTile(
              habit: habit,
              ontap: () {
                log('Habit tapped: ${habit.name}');
              },
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
    required this.ontap,
  });

  final HabitModel habit;
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
      onTap: widget.ontap,
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

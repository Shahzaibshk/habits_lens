import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vos/models/habit_record_model.dart';
import 'package:vos/utils/enum.dart';

import '../models/habit_model.dart';
import '../widgets/primary_rich_text.dart';

class GoodHabits extends HookWidget {
  const GoodHabits({super.key});

  @override
  Widget build(BuildContext context) {
    final goodHabitBox = Hive.box<HabitModel>(HiveBox.goodHabit.name);
    final habitRecordBox = Hive.box<HabitRecordModel>(HiveBox.habitRecord.name);
    String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return goodHabitBox.isEmpty
        ? const Center(child: Text('No item found'))
        : ValueListenableBuilder(
            valueListenable: goodHabitBox.listenable(),
            builder: (context, value, child) {
              // Get today's habit record
              final habitRecord = habitRecordBox.get(todayKey);
              List<HabitModel> checkedHabits = habitRecord?.goodHabits ?? [];

              return ListView.builder(
                itemCount: goodHabitBox.keys.length,
                itemBuilder: (context, index) {
                  final habit = goodHabitBox.getAt(index);
                  if (habit == null) return const SizedBox.shrink();

                  // Determine initial state from Hive
                  final isChecked = checkedHabits.contains(habit);
                  final isCheckedNotifier = ValueNotifier<bool>(isChecked);

                  return ListTile(
                    leading: PrimaryCheckBox(
                      habit: habit,
                      isCheckedNotifier: isCheckedNotifier,
                      onChange: (isChecked) {
                        if (isChecked) {
                          checkedHabits.add(habit);
                        } else {
                          checkedHabits.remove(habit);
                        }

                        // Save updated state to Hive
                        habitRecordBox.put(
                          todayKey,
                          HabitRecordModel(
                            badHabits: [],
                            goodHabits: checkedHabits,
                            time: todayKey,
                          ),
                        );
                      },
                    ),
                    title: Text(habit.name),
                    trailing: PrimaryRichText(
                      text: ' Points',
                      linkedText: habit.points.toString(),
                    ),
                  );
                },
              );
            },
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

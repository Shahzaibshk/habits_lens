import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/habit_record_model.dart';
import '../utils/app_textstyle.dart';
import '../utils/enum.dart';
import '../widgets/primary_card.dart';
import '../widgets/primary_error_widet.dart';

final habbitRecordProvider =
    FutureProvider.autoDispose<HabitRecordModel>((ref) async {
  final habitRecordBox = Hive.box<HabitRecordModel>(
    HiveBox.habitRecord.name,
  );
  String todayKey = DateFormat('yyyy-MM-dd').format(
    DateTime.now(),
  );
  final habitRecord = habitRecordBox.get(todayKey);
  if (habitRecord == null) {
    await habitRecordBox.put(
      todayKey,
      HabitRecordModel(
        time: todayKey,
        goodHabits: [],
        badHabits: [],
      ),
    );
    final habbitrecord = habitRecordBox.get(todayKey);
    return habbitrecord!;
  }
  return habitRecord;
});

class HabitCalculationScreen extends ConsumerWidget {
  const HabitCalculationScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final habbitRecordAsync = ref.watch(habbitRecordProvider);

    return habbitRecordAsync.when(
      data: (record) {
        final positivePoints = record.goodHabits.fold(
          0,
          (previousValue, element) => element.points + previousValue,
        );
        final nagativePoints = record.badHabits.fold(
          0,
          (previousValue, element) => element.points + previousValue,
        );
        final totalPoints = positivePoints + nagativePoints;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              PrimaryCard(
                child: ListTile(
                  leading: const Icon(
                    Icons.calendar_today,
                  ),
                  title: const Text('Date'),
                  trailing: Text(
                    record.time,
                    style: AppTextstyle.greenStyle,
                  ),
                ),
              ),

              const SizedBox(height: 10),
              PrimaryCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.add_circle_outline,
                      ),
                      title: const Text(
                        'Positive Points',
                      ),
                      trailing: Text(
                        '$positivePoints',
                        style: AppTextstyle.greenStyle,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.remove_circle_outline,
                      ),
                      title: const Text(
                        'Negative Points',
                      ),
                      trailing: Text(
                        nagativePoints.toString(),
                        style: AppTextstyle.redStyle,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(
                        totalPoints >= 0
                            ? Icons.trending_up
                            : Icons.trending_down,
                      ),
                      title: const Text(
                        'Net Points for Day',
                      ),
                      trailing: Text(
                        totalPoints.toString(),
                        style: totalPoints > 0
                            ? AppTextstyle.greenStyle
                            : AppTextstyle.redStyle,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Habit Lists
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (record.goodHabits.isNotEmpty) ...[
                        PrimaryCard(
                            color: Colors.green.shade100,
                            child: Text(
                              'Good Habits',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                        ...record.goodHabits.map(
                          (e) => ListTile(
                            leading: const Icon(Icons.check_circle,
                                color: Colors.green),
                            title: Text(e.name),
                            trailing: Text(
                              '${e.points}',
                              style: AppTextstyle.greenStyle,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      if (record.badHabits.isNotEmpty) ...[
                        PrimaryCard(
                            color: Colors.green.shade100,
                            child: Text(
                              'Bad Habits',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                        ...record.badHabits.map(
                          (e) => ListTile(
                            leading: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            title: Text(e.name),
                            trailing: Text(
                              e.points.toString(),
                              style: AppTextstyle.redStyle,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) =>
          Center(child: PrimaryErrorWidget(error: error)),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

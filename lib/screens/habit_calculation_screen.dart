import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vos/models/habit_record_model.dart';
import 'package:vos/utils/app_textstyle.dart';
import 'package:vos/utils/enum.dart';
import 'package:vos/widgets/primary_error_widet.dart';

final habbitRecordProvider = FutureProvider.autoDispose<HabitRecordModel>((ref) async {
  final habitRecordBox = Hive.box<HabitRecordModel>(
    HiveBox.habitRecord.name,
  );
  String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
        return Column(
          children: [
            IconButton(
                onPressed: () {
                  // Hive.box<HabitRecordModel>(
                  //   HiveBox.habitRecord.name,
                  // ).deleteFromDisk();
                },
                icon: Icon(Icons.delete)),
            ListTile(
              title: Text('Time'),
              trailing: Text(
                record.time,
                style: AppTextstyle.greenStyle,
              ),
            ),
            ListTile(
              title: Text('Postive Points'),
              trailing: Text(
                positivePoints.toString(),
                style: AppTextstyle.greenStyle,
              ),
            ),
            ListTile(
              title: Text('Negative points'),
              trailing: Text(
                nagativePoints.toString(),
                style: AppTextstyle.redStyle,
              ),
            ),
            ListTile(
              title: Text('Net Points for day'),
              trailing: Text(
                totalPoints.toString(),
                style: totalPoints > 0 ? AppTextstyle.greenStyle : AppTextstyle.redStyle,
              ),
            ),
            Divider(),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  ...record.goodHabits.map(
                    (e) => ListTile(
                      title: Text(e.name),
                      trailing: Text(
                        e.points.toString(),
                        style: AppTextstyle.greenStyle,
                      ),
                    ),
                  ),
                  Divider(
                    indent: 64,
                    endIndent: 64,
                  ),
                  ...record.badHabits.map(
                    (e) => ListTile(
                      title: Text(e.name),
                      trailing: Text(
                        e.points.toString(),
                        style: AppTextstyle.redStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ))
          ],
        );
      },
      error: (error, stackTrace) => PrimaryErrorWidget(error: error),
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

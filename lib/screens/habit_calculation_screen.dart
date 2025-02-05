import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vos/models/habit_record_model.dart';
import 'package:vos/utils/app_textstyle.dart';
import 'package:vos/utils/enum.dart';

class HabitCalculationScreen extends HookWidget {
  const HabitCalculationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final habitRecordBox = Hive.box<HabitRecordModel>(
      HiveBox.habitRecord.name,
    );
    final habitRecord = habitRecordBox.get(todayKey);
    final goodHabits = habitRecord?.goodHabits;
    final badHabits = habitRecord?.badHabits;
    final positivePoints = goodHabits?.fold(
      0,
      (prev, element) => prev + element.points,
    );

    final negativePoints = badHabits?.fold(
      0,
      (prev, element) => prev + element.points,
    );

    final totalPoints = positivePoints! + negativePoints!;
    if (habitRecord == null) {
      return Center(child: Text('No habit found'));
    } else {
      return Column(
        children: [
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
              negativePoints.toString(),
              style: AppTextstyle.redStyle,
            ),
          ),
          ListTile(
            title: Text('Net Points for day'),
            trailing: Text(
              totalPoints.toString(),
              style: totalPoints >= 0
                  ? AppTextstyle.greenStyle
                  : AppTextstyle.redStyle,
            ),
          )
        ],
      );
    }
  }
}

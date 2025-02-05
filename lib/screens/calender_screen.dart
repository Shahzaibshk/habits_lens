import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vos/models/habit_record_model.dart';
import 'package:vos/utils/enum.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  @override
  Widget build(BuildContext context) {
    final recordsBox = Hive.box<HabitRecordModel>(HiveBox.habitRecord.name);
    return Column(
      children: [
        TableCalendar(
          focusedDay: DateTime.now(),
          firstDay: DateTime.utc(2022),
          lastDay: DateTime.utc(2030),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              final formatedDay = DateFormat('yyyy-MM-dd').format(day);
              final records = recordsBox.values.toList();

              if (records.map((e) => e.time).toList().contains(formatedDay)) {
                final record = records.firstWhere((element) => element.time == formatedDay);
                final positivePoints = record.goodHabits.fold(
                  0,
                  (previousValue, element) => element.points + previousValue,
                );
                final nagativePoints = record.badHabits.fold(
                  0,
                  (previousValue, element) => element.points + previousValue,
                );
                final totalPoints = positivePoints + nagativePoints;
                return Text(totalPoints.toString());
              }

              return SizedBox.shrink();
            },
          ),
        )
      ],
    );
  }
}

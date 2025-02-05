import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


import '../models/habit_record_model.dart';
import '../utils/app_colors.dart';
import '../utils/enum.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    final recordsBox = Hive.box<HabitRecordModel>(HiveBox.habitRecord.name);
    return Column(
      children: [
        TableCalendar(
          focusedDay: DateTime.now(),
          firstDay: DateTime.utc(2024),
          lastDay: DateTime.utc(2030),
          calendarStyle: CalendarStyle(
            defaultDecoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            todayDecoration: BoxDecoration(
              color: Colors.blue.shade400,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              return Center(
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              return Center(
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              );
            },
            markerBuilder: (context, day, events) {
              final formattedDay = DateFormat('yyyy-MM-dd').format(day);
              final records = recordsBox.values.toList();
              if (records.map((e) => e.time).contains(formattedDay)) {
                final record = records.firstWhere(
                  (element) => element.time == formattedDay,
                );
                final positivePoints = record.goodHabits.fold(
                  0,
                  (previousValue, element) => element.points + previousValue,
                );
                final negativePoints = record.badHabits.fold(
                  0,
                  (previousValue, element) => element.points + previousValue,
                );
                final totalPoints = positivePoints + negativePoints;
                return Positioned(
                  bottom: -6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: totalPoints >= 0
                          ? AppColors.primary
                          : Colors.red.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      totalPoints.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

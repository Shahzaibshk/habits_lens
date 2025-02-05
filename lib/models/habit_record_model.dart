import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:vos/models/habit_model.dart';

part 'habit_record_model.g.dart';

@HiveType(typeId: 2)
class HabitRecordModel {
  @HiveField(0)
  String time;
  @HiveField(1)
  List<HabitModel> goodHabits;
  @HiveField(2)
  List<HabitModel> badHabits;

  HabitRecordModel(
      {required this.badHabits, required this.goodHabits, required this.time});
}

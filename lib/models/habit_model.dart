import 'package:hive_ce_flutter/hive_flutter.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 1)
class HabitModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  int points;

  HabitModel({
    required this.name,
    required this.points,
  });
}

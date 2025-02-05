import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hoppy/models/habit_record_model.dart';
import 'package:hoppy/utils/enum.dart';
import 'package:path_provider/path_provider.dart';

import 'models/habit_model.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  Hive.registerAdapter(HabitModelAdapter());
  Hive.registerAdapter(HabitRecordModelAdapter());
  await Hive.openBox<HabitModel>(HiveBox.goodHabit.name);
  await Hive.openBox<HabitModel>(HiveBox.badHabit.name);
  await Hive.openBox<HabitRecordModel>(HiveBox.habitRecord.name);

  runApp(ProviderScope(
    child: MyApp(),
  ));
}

// Lock the Portrait Orientation.
void _setPortraitMode() {
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
}

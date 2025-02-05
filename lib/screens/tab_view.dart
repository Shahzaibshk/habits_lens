import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../models/habit_record_model.dart';
import '../utils/enum.dart';
import 'bad_habits_screen.dart';
import 'calender_screen.dart';
import 'good_habits_screen.dart';
import 'habit_summary_screen.dart';
import 'widget/primary_dialog.dart';

class TabView extends StatefulWidget {
  const TabView({super.key});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int _currentIndex = 0;
  String get _appBarTitle {
    switch (_currentIndex) {
      case 0:
        return 'Daily Habit Summary';
      case 1:
        return 'Good Habits';
      case 2:
        return 'Bad Habits';
      case 3:
        return 'Calender';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _currentIndex == 0
            ? AppBar(
                title: Text(_appBarTitle),
                actions: [
                  IconButton(
                    onPressed: () {
                      Hive.box<HabitRecordModel>(HiveBox.habitRecord.name)
                          .deleteFromDisk();
                    },
                    icon: const Icon(
                      Icons.delete_outline_outlined,
                    ),
                  ),
                ],
              )
            : AppBar(
                title: Text(_appBarTitle),
              ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HabitCalculationScreen(),
            GoodHabits(),
            BadHabits(),
            CalendarScreen()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              _currentIndex = index;
              setState(() {});
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Summary',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events_outlined),
                label: 'Good Habits',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.do_not_disturb_alt_outlined),
                label: 'Bad Habits',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event_available_outlined),
                label: 'Calender',
              ),
            ]),
        floatingActionButton: (_currentIndex == 1 || _currentIndex == 2)
            ? FloatingActionButton(
                onPressed: () {
                  bool isGoodHabitScreen = _currentIndex == 1;
                  PrimmaryHabit(isFromGoodHabit: isGoodHabitScreen)
                      .show(context);
                },
                child: const Icon(Icons.add),
              )
            : null);
  }
}

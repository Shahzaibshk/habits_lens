import 'package:flutter/material.dart';
import 'package:vos/screens/bad_habits_screen.dart';
import 'package:vos/screens/calender_screen.dart';
import 'package:vos/screens/good_habits_screen.dart';
import 'package:vos/screens/habit_calculation_screen.dart';
import 'package:vos/screens/widget/primary_dialog.dart';

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
        return 'Calculation';
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
        appBar: AppBar(
          title: Text(_appBarTitle),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HabitCalculationScreen(),
            GoodHabits(),
            BadHabits(),
            CalenderScreen()
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
                icon: Icon(Icons.calculate_outlined),
                label: 'Calculate',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Good Habits',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Bad Habits',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
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

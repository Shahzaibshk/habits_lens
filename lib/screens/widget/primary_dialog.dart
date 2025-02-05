import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import 'package:vos/utils/enum.dart';

import '../../models/habit_model.dart';
import '../../utils/validators.dart';
import '../../widgets/primary_text_field.dart';

class PrimmaryHabit extends HookWidget {
  const PrimmaryHabit({super.key, required this.isFromGoodHabit});
  final bool isFromGoodHabit;

  @override
  Widget build(BuildContext context) {
    String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final goodHabitBox = Hive.box<HabitModel>(HiveBox.goodHabit.name);
    final badHabitBox = Hive.box<HabitModel>(HiveBox.badHabit.name);

    final nameController = useTextEditingController();
    final pointsController = useTextEditingController();
    final formKey = GlobalObjectKey<FormState>(context);

    Future<void> addHabit() async {
      if (formKey.currentState!.validate()) {
        final name = nameController.text.toString();
        final points = int.tryParse(pointsController.text.toString());
        final habitModel = HabitModel(
          name: name,
          points: points ?? 0,
        );

        if (!isFromGoodHabit && points! >= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bad habits must be in negative points'),
            ),
          );
          return;
        }
        if (isFromGoodHabit && points! < 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Good habit must be in poistive points'),
            ),
          );

          return;
        }

        if (isFromGoodHabit) {
          await goodHabitBox.put(todayKey, habitModel);
          print(goodHabitBox.keys.toList());
        } else {
          await badHabitBox.put(todayKey, habitModel);
        }

        Navigator.of(context).pop();
      }
    }

    return AlertDialog(
      title: Text("Let's make a new habit"),
      actions: <Widget>[
        Form(
          key: formKey,
          child: Column(
            children: [
              PrimaryTextField(
                validator: Validators.emptyValidator,
                controller: nameController,
                hintText: 'Habit Name',
              ),
              PrimaryTextField(
                keyboardType: TextInputType.number,
                validator: Validators.emptyValidator,
                controller: pointsController,
                hintText: 'Enter your points',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await addHabit();
                    },
                    child: const Text('Add'),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<void> show(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return PrimmaryHabit(
          isFromGoodHabit: isFromGoodHabit,
        );
      },
    );
  }
}

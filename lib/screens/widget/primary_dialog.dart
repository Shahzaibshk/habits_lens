import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_ce/hive.dart';
import 'package:hoppy/widgets/primary_button.dart';

import '../../models/habit_model.dart';
import '../../utils/enum.dart';
import '../../utils/validators.dart';
import '../../widgets/primary_text_field.dart';

class PrimmaryHabit extends HookWidget {
  const PrimmaryHabit({super.key, required this.isFromGoodHabit});
  final bool isFromGoodHabit;

  @override
  Widget build(BuildContext context) {
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
        if (goodHabitBox.values.any((element) => element.name == name) ||
            badHabitBox.values.any((element) => element.name == name)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Habit already exists'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        if (isFromGoodHabit) {
          await goodHabitBox.add(habitModel);
        } else {
          await badHabitBox.add(habitModel);
        }

        Navigator.pop(context);
      }
    }

    return AlertDialog(
      title: Text(
        "Create a New Habit",
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      contentPadding: EdgeInsets.all(16.0),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryTextField(
              validator: Validators.emptyValidator,
              controller: nameController,
              hintText: 'Habit Name',
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 12),
            PrimaryTextField(
              keyboardType: TextInputType.number,
              validator: (value) => Validators.pointsValidator(value, isGoodHabit: isFromGoodHabit),
              controller: pointsController,
              hintText: 'Enter your points',
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PrimaryButton(
                  onTap: () => Navigator.pop(context),
                  width: 100,
                  text: 'Cancel',
                  color: Colors.grey.shade400,
                  textStyle: TextStyle(color: Colors.black),
                ),
                PrimaryButton(
                  onTap: () async {
                    await addHabit();
                  },
                  width: 100,
                  text: 'Add',
                  textStyle: TextStyle(color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
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

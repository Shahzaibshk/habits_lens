// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitRecordModelAdapter extends TypeAdapter<HabitRecordModel> {
  @override
  final int typeId = 2;

  @override
  HabitRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitRecordModel(
      badHabits: (fields[2] as List).cast<HabitModel>(),
      goodHabits: (fields[1] as List).cast<HabitModel>(),
      time: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HabitRecordModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.goodHabits)
      ..writeByte(2)
      ..write(obj.badHabits);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

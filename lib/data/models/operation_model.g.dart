// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OperationModelHiveAdapter extends TypeAdapter<OperationModelHive> {
  @override
  final int typeId = 0;

  @override
  OperationModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OperationModelHive(
      id: fields[0] as int,
      action: fields[1] as String,
      date: fields[2] as String,
      type: fields[3] as String,
      form: fields[4] as String,
      sum: fields[5] as int,
      note: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OperationModelHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.action)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.form)
      ..writeByte(5)
      ..write(obj.sum)
      ..writeByte(6)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

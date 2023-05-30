// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OperationHiveAdapter extends TypeAdapter<OperationHive> {
  @override
  final int typeId = 0;

  @override
  OperationHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OperationHive(
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
  void write(BinaryWriter writer, OperationHive obj) {
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
      other is OperationHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Operation _$OperationFromJson(Map<String, dynamic> json) => Operation(
      id: json['id'] as int,
      action: json['action'] as String,
      date: json['date'] as String,
      type: json['type'] as String,
      form: json['form'] as String,
      sum: json['sum'] as int,
      note: json['note'] as String,
    );

Map<String, dynamic> _$OperationToJson(Operation instance) => <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'date': instance.date,
      'type': instance.type,
      'form': instance.form,
      'sum': instance.sum,
      'note': instance.note,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SenderState _$SenderStateFromJson(Map<String, dynamic> json) => SenderState(
      operations: (json['operations'] as List<dynamic>?)
              ?.map((e) => Operation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isLoading: json['isLoading'] as bool? ?? false,
      isError: json['isError'] as bool? ?? false,
    );

Map<String, dynamic> _$SenderStateToJson(SenderState instance) =>
    <String, dynamic>{
      'operations': instance.operations,
      'isLoading': instance.isLoading,
      'isError': instance.isError,
    };

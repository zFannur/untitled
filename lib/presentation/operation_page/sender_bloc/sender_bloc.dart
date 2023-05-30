
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../domain/entity/operation.dart';


part 'sender_event.dart';
part 'sender_state.dart';
part 'sender_bloc.g.dart';

class SenderBloc extends Bloc<SenderEvent, SenderState> with HydratedMixin{
  SenderBloc() : super(const SenderState()) {
    on<SenderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  SenderState? fromJson(Map<String, dynamic> json) => SenderState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(SenderState state) => state.toJson();
}

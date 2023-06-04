import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'operation_change_event.dart';

part 'operation_change_state.dart';

class OperationChangeBloc
    extends Bloc<OperationChangeEvent, OperationChangeState> {
  OperationChangeBloc() : super(const OperationChangeState()) {
    on<ChangeIndexEvent>(_onChangeIndexEvent);
    on<ChangeOperationEvent>(_onChangeOperationEvent);
  }

  _onChangeIndexEvent(ChangeIndexEvent event, Emitter<OperationChangeState> emit) {
    emit(state.copyWith(index: event.index));
  }

  _onChangeOperationEvent(
      ChangeOperationEvent event, Emitter<OperationChangeState> emit) {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(
      isLoading: false,
      index: event.index,
      date: event.date,
      type: event.type,
      form: event.form,
      sum: event.sum,
      note: event.note
    ));
  }
}

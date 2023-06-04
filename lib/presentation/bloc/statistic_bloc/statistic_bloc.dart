import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistic_event.dart';
part 'statistic_state.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  StatisticBloc() : super(const StatisticState()) {
    on<ChangeStatisticEvent>(_onChangeStatisticEvent);
  }

  _onChangeStatisticEvent(
      ChangeStatisticEvent event, Emitter<StatisticState> emit) {
    emit(state.copyWith(dropdownValue: event.dropdownValue));
  }
}

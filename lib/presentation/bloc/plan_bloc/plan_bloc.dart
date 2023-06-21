import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:untitled/domain/use_case/plan_use_case.dart';

import '../../../domain/entity/plan.dart';

part 'plan_event.dart';
part 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final PlanUseCase planUseCase;

  PlanBloc(this.planUseCase) : super(const PlanState()) {
    on<GetPlanEvent>(_onGetPlanEvent);
    //on<AddPlanEventEvent>(_onAddPlanEvent);
    //on<DeletePlanEventEvent>(_onDeletePlanEvent);
    //on<EditPlanEventEvent>(_onEditPlanEvent);


  }

  _onGetPlanEvent(
      GetPlanEvent event, Emitter<PlanState> emit) async {
    emit(state.copyWith(isLoading: true));
    final isConnect = await InternetConnectionChecker().hasConnection;
    List<Plan> plans = [];

    if (isConnect) {
      plans = await planUseCase.getPlan();
    }

    emit(state.copyWith(plans: plans, isLoading: false));
  }
}

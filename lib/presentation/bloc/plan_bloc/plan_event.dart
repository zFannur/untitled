part of 'plan_bloc.dart';

abstract class PlanEvent extends Equatable {
  const PlanEvent();
}

class GetPlanEvent extends PlanEvent {
  @override
  List<Object?> get props => [];
}

class AddPlanEvent extends PlanEvent {
  @override
  List<Object?> get props => [];
}

class EditPlanEvent extends PlanEvent {
  @override
  List<Object?> get props => [];
}

class DeletePlanEvent extends PlanEvent {
  @override
  List<Object?> get props => [];
}
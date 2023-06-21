part of 'plan_bloc.dart';

class PlanState extends Equatable {
  final List<Plan> plans;
  final bool isLoading;

  const PlanState({
    this.plans = const [],
    this.isLoading = false,
  });

  PlanState copyWith({
    List<Plan>? plans,
    bool? isLoading,
  }) {
    return PlanState(
      plans: plans ?? this.plans,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        plans,
        isLoading,
      ];
}

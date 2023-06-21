import '../entity/plan.dart';

abstract class PlanUseCase {
  Future<List<Plan>> getPlan();

  void deletePlan(int id);

  List<Plan> editPlan({
    required int id,
    required String date,
    required String name,
    required String sum,
  });

  Future<void> addPlan({
    required String date,
    required String name,
    required String sum,
  });
}
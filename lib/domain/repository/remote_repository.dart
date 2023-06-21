import '../entity/operation.dart';
import '../entity/plan.dart';

abstract class RemoteRepository {
  Future<List<Operation>> getOperation();
  Future<String> postOperation(Operation operation);

  Future<List<Plan>> getPlan();
  Future<String> postPlan(Operation operation);
}
import 'package:untitled/domain/entity/plan.dart';
import 'package:untitled/domain/use_case/plan_use_case.dart';

import '../repository/local_repository.dart';
import '../repository/remote_repository.dart';

class PlanUseCaseImpl extends PlanUseCase {
  final LocalRepository localRepository;
  final RemoteRepository remoteRepository;

  PlanUseCaseImpl({required this.localRepository, required this.remoteRepository});

  @override
  Future<void> addPlan({required String date, required String name, required String sum}) {
    // TODO: implement addPlan
    throw UnimplementedError();
  }

  @override
  List<Plan> editPlan({required int id, required String date, required String name, required String sum}) {
    // TODO: implement editPlan
    throw UnimplementedError();
  }

  @override
  Future<List<Plan>> getPlan() async {
    List<Plan> remote = [];

    try {
        remote = await remoteRepository.getPlan();
        return remote;
    } catch (_) {
    return [];
    }
  }

  @override
  void deletePlan(int id) {
    // TODO: implement deletePlan
  }

}
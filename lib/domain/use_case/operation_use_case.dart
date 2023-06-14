import '../entity/operation.dart';

abstract class OperationUseCase {

  Future<List<Operation>> getOperation();

  void deleteOperation(int index, int id);

  List<Operation> editOperation({
    required int index,
    required int id,
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  });

  Future<List<Operation>> addOperation({
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  });

  Future<void> sendOperation({
    required String action,
    required int id,
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  });

  List<Operation> getCache();
}

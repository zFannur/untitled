import '../entity/operation.dart';

abstract class RemoteRepository {
  Future<List<Operation>> getOperation();
  Future<String> postOperation(Operation operation);
}
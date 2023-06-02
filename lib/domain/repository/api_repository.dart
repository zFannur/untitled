import '../entity/operation.dart';

abstract class ApiClient {
  Future<List<Operation>> getForm();
  Future<String> postForm(Operation operation);
}
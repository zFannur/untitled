import 'package:untitled/domain/entity/operation.dart';
import '../repository/api_repository.dart';

abstract class ApiUseCase {
  Future<List<Operation>> getOperation();

  Future<String> sendOperation({
    required String action,
    required int id,
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  });
}

class ApiUseCaseImpl implements ApiUseCase{
  late final ApiClient _apiClient;

  ApiUseCaseImpl({required apiClient}) : _apiClient = apiClient;


  @override
  Future<List<Operation>> getOperation() async {
    return await _apiClient.getForm();
  }

  @override
  Future<String> sendOperation({
    required String action,
    required int id,
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  }) async {
    final operation = Operation(
      action: action,
      date: date,
      type: type,
      form: form,
      sum: sum,
      note: note,
      id: id,
    );
    return await _apiClient.postForm(operation);
  }
}

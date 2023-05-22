import 'package:untitled/data/api/api_client.dart';
import 'package:untitled/domain/entity/operation.dart';

class ApiService {
  final _apiClient = ApiClient();

  Future<List<Operation>> getOperation() async {
    return await _apiClient.getForm();
  }

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

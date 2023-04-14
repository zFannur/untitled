import 'package:untitled/data/api/api_client.dart';
import 'package:untitled/domain/entity/operation.dart';

class OperationService {
  final _apiClient = ApiClient();

  Future<List<Operation>> getOperation() async {
    return await _apiClient.getForm();
  }

  Future<String> sendOperation({
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  }) async {
    final operation = Operation(
      action: 'put',
      date: date,
      type: type,
      form: form,
      sum: sum,
      note: note,
      id: 0,
    );
    return await _apiClient.postForm(operation);
  }

  Future<String> deleteOperation(int id) async {
    final operation = Operation(
      action: 'del',
      date: '',
      type: '',
      form: '',
      sum: 0.toInt(),
      note: '',
      id: id,
    );

    return await _apiClient.postForm(operation);
  }
}

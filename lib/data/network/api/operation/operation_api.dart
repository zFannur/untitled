import 'package:dio/dio.dart';
import 'package:untitled/domain/entity/operation.dart';

import '../../../models/converter.dart';
import '../../dio_client.dart';
import '../constant/endpoints.dart';

class OperationApi {
  final DioClient dioClient;

  OperationApi({required this.dioClient});

  Future<Response> addOperationApi(Operation operation) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.exec,
        data: ConvertOperation.operationToOperationApi(operation),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getOperationApi() async {
    try {
      final Response response = await dioClient.get(Endpoints.exec);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateOperationApi(Operation operation) async {
    try {
      final Response response = await dioClient.put(
        Endpoints.exec,
        data: ConvertOperation.operationToOperationApi(operation),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteOperationApi(int id) async {
    try {
      await dioClient.delete(Endpoints.exec);
    } catch (e) {
      rethrow;
    }
  }
}

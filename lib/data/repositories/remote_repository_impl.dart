import 'package:dio/dio.dart';
import 'package:untitled/domain/entity/operation.dart';
import 'package:untitled/domain/repository/remote_repository.dart';

import '../models/converter.dart';
import '../models/operation_model.dart';
import '../network/api/constant/endpoints.dart';
import '../network/dio_exception.dart';

class RemoteRepositoryImplNew extends RemoteRepository {
  final Dio _dio;

  RemoteRepositoryImplNew(this._dio) {
    // _dio
    // //..options.baseUrl = Endpoints.baseUrl
    //   ..options.connectTimeout = Endpoints.connectionTimeout
    //   ..options.receiveTimeout = Endpoints.receiveTimeout
    //   ..options.responseType = ResponseType.json
    //   ..interceptors.add(LogInterceptor(
    //     request: true,
    //     requestHeader: true,
    //     requestBody: true,
    //     responseHeader: true,
    //     responseBody: true,
    //   ));
  }

  @override
  Future<List<Operation>> getOperation() async {
    try {
      final response = await _dio.get(Endpoints.baseUrl);
      final operations = ConvertOperation.operationApiToOperationList(
          (response.data as List)
              .map((json) => OperationModel.fromJson(json))
              .toList());
      return operations;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  @override
  Future<String> postOperation(Operation operation) async {
    String status = '';
    final operationModel = ConvertOperation.operationToOperationApi(operation);

    final json = operationModel.toJson();
    try {
      await _dio.postUri(
        Uri.parse(Endpoints.baseUrl),
        data: json,
      );

      return status;

    } on DioException catch (e) {

      if (e.type == DioExceptionType.badResponse) {
        if (e.response?.statusCode == 302) {
          var unary = e.response?.headers?.map['location']?.first as String;
          final response = await _dio.get(unary);
          return status = response.data['status'] as String;
        } else {
          return status = 'FAILED';
        }
      }

      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}

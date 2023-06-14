import 'package:dio/dio.dart';
import 'package:untitled/data/network/api/operation/operation_api.dart';
import 'package:untitled/domain/entity/operation.dart';
import 'package:untitled/domain/repository/remote_repository.dart';

import '../models/converter.dart';
import '../models/operation_model.dart';
import '../network/dio_exception.dart';


class RemoteRepositoryImplNew extends RemoteRepository{
  final OperationApi operationApi;

  RemoteRepositoryImplNew(this.operationApi);

  Future<List<Operation>> getOperationRequested() async {
    try {
      final response = await operationApi.getOperationApi();
      final operations = ConvertOperation.operationApiToOperationList((response.data as List).map((json) => OperationModel.fromJson(json)).toList());
      return operations;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<Operation> addOperationRequested(Operation operation) async {
    try {
      final response = await operationApi.addOperationApi(operation);
      return Operation.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<Operation> updateOperationRequested(Operation operation) async {
    try {
      final response = await operationApi.updateOperationApi(operation);
      return Operation.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<void> deleteOperationRequested(int id) async {
    try {
      await operationApi.deleteOperationApi(id);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  @override
  Future<List<Operation>> getOperation() async {
    try {
      final response = await operationApi.getOperationApi();
      final operations = ConvertOperation.operationApiToOperationList((response.data as List).map((json) => OperationModel.fromJson(json)).toList());
      return operations;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  @override
  Future<String> postOperation(Operation operation) async {
    String status = '';

    try {
      final response = await operationApi.addOperationApi(operation);
      if (response.statusCode == 302) {
        // var unary = Uri.parse(response.headers);
        // await http.get(unary).then((response) {
        //   status = (convert.jsonDecode(response.body)['status']);
        // });
      } else {
        status =  'StatusCodeError';
      }
      return status;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}

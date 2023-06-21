import 'package:untitled/data/models/plan_model.dart';
import 'package:untitled/data/network/api/constant/endpoints.dart';
import 'package:untitled/domain/entity/operation.dart';

import 'package:untitled/domain/repository/remote_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:untitled/data/models/converter.dart';
import 'package:untitled/data/models/operation_model.dart';

import '../../domain/entity/plan.dart';

class RemoteRepositoryImpl extends RemoteRepository {
  RemoteRepositoryImpl();

  @override
  Future<List<Operation>> getOperation() async {

    try {
      return await http.get(Uri.parse(Endpoints.operationUrl)).then((response) {
        var jsonForm = convert.jsonDecode(response.body) as List;
        return ConvertOperation.operationApiToOperationList(jsonForm.map((json) => OperationModel.fromJson(json)).toList());
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> postOperation(Operation operation) async {
    final operationApi = ConvertOperation.operationToOperationApi(operation);
    String status = '';

    try {
      final url = Uri.parse(Endpoints.operationUrl);

      var json = operationApi.toJson();

      await http.post(url, body: json).then((response) async {
        if (response.statusCode == 302) {
          var unary = Uri.parse(response.headers['location']!);
          await http.get(unary).then((response) {
            status = (convert.jsonDecode(response.body)['status']);
          });
        } else {
          status =  'StatusCodeError';
        }
      });
    } catch (e) {
      status = 'error';
    }
    return status;
  }



  @override
  Future<List<Plan>> getPlan() async {
    try {
      return await http.get(Uri.parse(Endpoints.planUrl)).then((response) {
        var jsonForm = convert.jsonDecode(response.body) as List;
        final planModel = jsonForm.map((json) => PlanModel.fromJson(json)).toList();
        final plans = planModel.map((e) => Plan(date: e.date, name: e.name, sum: e.sum, id: e.id)).toList();
        return plans;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> postPlan(Operation operation) {
    // TODO: implement postPlan
    throw UnimplementedError();
  }

}
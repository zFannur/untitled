import 'package:untitled/domain/entity/operation.dart';

import 'package:untitled/domain/repository/remote_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:untitled/data/models/converter.dart';
import 'package:untitled/data/models/operation_model.dart';

const uri =
    "https://script.google.com/macros/s/AKfycbySJsChZ2hhhjSqc5V_MPdic2rSMzhBIqs1MFSHsOi_Gpxl5UKR_t-pIPHlZHSF1EQrhg/exec";

class RemoteRepositoryImpl extends RemoteRepository {
  RemoteRepositoryImpl();

  @override
  Future<List<Operation>> getOperation() async {

    try {
      return await http.get(Uri.parse(uri)).then((response) {
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
      final url = Uri.parse(uri);

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

}